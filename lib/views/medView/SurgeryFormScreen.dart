import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medrecs/util/serializables/Surgery.dart';
import 'package:medrecs/util/serializables/UserHasAccess.dart';
import 'package:medrecs/util/services/blockWriterService.dart';
import 'package:medrecs/util/services/blockAccessorService.dart';

class SurgeryFormScreen extends StatefulWidget {
  final int userID;

  const SurgeryFormScreen({Key? key, required this.userID})
      : super(key: key);

  @override
  _SurgeryFormScreenState createState() => _SurgeryFormScreenState();
}

class _SurgeryFormScreenState extends State<SurgeryFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController surgeryNameController = TextEditingController();
  final TextEditingController hospitalIdController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  List<TextEditingController> surgeonTeamIdControllers = [TextEditingController()];
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Surgery Form'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: userIdController,
                  decoration: const InputDecoration(labelText: 'User ID'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter User ID';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: surgeryNameController,
                  decoration: const InputDecoration(labelText: 'Surgery Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Surgery Name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: hospitalIdController,
                  decoration: const InputDecoration(labelText: 'Hospital ID'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Hospital ID';
                    }
                    return null;
                  },
                ),
                for (int i = 0; i < surgeonTeamIdControllers.length; i++)
                  TextFormField(
                    controller: surgeonTeamIdControllers[i],
                    decoration: InputDecoration(labelText: 'Surgeon ID ${i + 1}'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Surgeon ID';
                      }
                      return null;
                    },
                  ),
                Row(
                  children: [
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          surgeonTeamIdControllers.add(TextEditingController());
                        });
                      },
                      child: const Text('Add Field'),
                    ),
                    const SizedBox(width: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (surgeonTeamIdControllers.length > 1) {
                            surgeonTeamIdControllers.removeLast();
                          }
                        });
                      },
                      child: const Text('Delete Field'),
                    ),
                    const Spacer(),
                  ],
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Description';
                    }
                    return null;
                  },
                ),
                // Date Picker
                InkWell(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Date',
                      hintText: 'Select Date',
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          selectedDate != null
                              ? "${selectedDate!.toLocal()}".split(' ')[0]
                              : 'Select Date',
                        ),
                        const Icon(Icons.calendar_today),
                      ],
                    ),
                  ),
                ),
                TextFormField(
                  controller: notesController,
                  decoration: const InputDecoration(labelText: 'Notes'),
                  // You can leave this field empty
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      submitSurgeryData();
                    }
                  },
                  child: const Text('Submit Surgery Data'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void submitSurgeryData() async {
    try {
      List<UserHasAccess> users =
      await blockAccessorService.getUsersDoctorHasAccessTo(widget.userID);

      List<int> surgeonTeamIds = surgeonTeamIdControllers
          .map((controller) => int.parse(controller.text))
          .toList();

      if (!_checkUserID(users, int.parse(userIdController.text))) {
        _showInvalidUserDialog();
      } else if (!await _checkDoctorsID(surgeonTeamIds)) {
        _showInvalidDoctorDialog();
      } else {
        Surgery surgeryData = Surgery(
          userID: int.parse(userIdController.text),
          surgeryName: surgeryNameController.text,
          hospitalID: int.parse(hospitalIdController.text),
          surgeonTeamIDs: surgeonTeamIds,
          description: descriptionController.text,
          date: selectedDate != null ? selectedDate!.toLocal().toString().split(' ')[0] : '',
          notes: notesController.text,
        );

        await blockWriterService.write(surgeryData.userID, surgeryData);

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Surgery Data submitted successfully!'),
        ));

        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to submit Surgery Data.'),
      ));
    }
  }

  bool _checkUserID(List<UserHasAccess> users, int userID) {
    return users.any((user) => user.userID == userID);
  }

  Future<bool> _checkDoctorsID(List<int> surgeonTeamIDs) async {
    int ids = surgeonTeamIDs.length;
    int count = 0;
    List<String> firebaseIDs = [];
    CollectionReference collectionReference =
    FirebaseFirestore.instance.collection('SocialSec');

    try {
      QuerySnapshot querySnapshot = await collectionReference
          .where("MedTeam", isEqualTo: true)
          .get();

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        firebaseIDs.add(documentSnapshot.id);
      }

      for (int doctorID in surgeonTeamIDs) {
        if (firebaseIDs.contains(doctorID.toString())) {
          count++;
        }
      }
    } catch (e) {
      print('Error: $e');
    }
    return ids == count;
  }

  void _showInvalidUserDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Invalid User ID'),
          content: const Text("That ID doesn't exist or you don't have access. Please try again."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showInvalidDoctorDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Invalid Doctor ID'),
          content: const Text("Surgeon ID not found. Please try again."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }
}
