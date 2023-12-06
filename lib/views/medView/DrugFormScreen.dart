import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medrecs/util/serializables/Drug.dart';
import 'package:medrecs/util/serializables/UserHasAccess.dart';
import 'package:medrecs/util/services/blockWriterService.dart';
import 'package:medrecs/util/services/blockAccessorService.dart';

class DrugFormScreen extends StatefulWidget {
  final int userID;

  const DrugFormScreen({Key? key, required this.userID})
      : super(key: key);

  @override
  _DrugFormScreenState createState() => _DrugFormScreenState();
}

class _DrugFormScreenState extends State<DrugFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController userIDController = TextEditingController();
  final TextEditingController doctorIDController = TextEditingController();
  final TextEditingController drugController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drug Form'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: userIDController,
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
                  controller: doctorIDController,
                  decoration: const InputDecoration(labelText: 'Doctor ID'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Doctor ID';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: drugController,
                  decoration: const InputDecoration(labelText: 'Drug'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Drug';
                    }
                    return null;
                  },
                ),
                // Start Date Picker
                InkWell(
                  onTap: () {
                    _selectStartDate(context);
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Start Date',
                      hintText: 'Select Date',
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          selectedStartDate != null
                              ? "${selectedStartDate!.toLocal()}".split(' ')[0]
                              : 'Select Date',
                        ),
                        const Icon(Icons.calendar_today),
                      ],
                    ),
                  ),
                ),
                // End Date Picker
                InkWell(
                  onTap: () {
                    _selectEndDate(context);
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'End Date',
                      hintText: 'Select Date',
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          selectedEndDate != null
                              ? "${selectedEndDate!.toLocal()}".split(' ')[0]
                              : 'Select Date',
                        ),
                        const Icon(Icons.calendar_today),
                      ],
                    ),
                  ),
                ),
                TextFormField(
                  controller: reasonController,
                  decoration: const InputDecoration(labelText: 'Reason'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Reason';
                    }
                    return null;
                  },
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
                      submitDrugData();
                    }
                  },
                  child: const Text('Submit Drug Data'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void submitDrugData() async {
    try {
      List<UserHasAccess> users =
      await blockAccessorService.getUsersDoctorHasAccessTo(widget.userID);

      if (!_checkUserID(users, int.parse(userIDController.text))) {
        _showErrorDialog(
            "Invalid User ID",
            "That ID doesn't exist or you don't have access. Please try again.");
      } else if (!await _checkDoctorID(doctorIDController.text)) {
        _showErrorDialog(
            "Invalid Doctor ID", "That ID doesn't exist. Please try again.");
      } else {
        Drug drugData = Drug(
          userID: int.parse(userIDController.text),
          doctorID: int.parse(doctorIDController.text),
          drug: drugController.text,
          startDate: startDateController.text,
          endDate: endDateController.text,
          reason: reasonController.text,
          notes: notesController.text,
        );

        await blockWriterService.write(drugData.userID, drugData);

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Drug Data submitted successfully!'),
        ));

        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to submit Drug Data.'),
      ));
    }
  }

  bool _checkUserID(List<UserHasAccess> users, int userID) {
    return users.any((user) => user.userID == userID);
  }

  Future<bool> _checkDoctorID(String doctorID) async {
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
    } catch (e) {
      _showErrorDialog("There was some error", 'Error: $e');
    }
    return firebaseIDs.contains(doctorID);
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
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

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != selectedStartDate) {
      setState(() {
        selectedStartDate = pickedDate;
        startDateController.text =
        pickedDate.toLocal().toString().split(' ')[0];
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != selectedEndDate) {
      setState(() {
        selectedEndDate = pickedDate;
        endDateController.text =
        pickedDate.toLocal().toString().split(' ')[0];
      });
    }
  }
}
