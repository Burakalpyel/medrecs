import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medrecs/util/serializables/Incident.dart';
import 'package:medrecs/util/serializables/UserHasAccess.dart';
import 'package:medrecs/util/services/blockWriterService.dart';
import 'package:medrecs/util/services/blockAccessorService.dart';

class IncidentFormScreen extends StatefulWidget {
  final int userID;

  const IncidentFormScreen({Key? key, required this.userID})
      : super(key: key);


  @override
  _IncidentFormScreenState createState() => _IncidentFormScreenState();
}

class _IncidentFormScreenState extends State<IncidentFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController incidentController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  List<TextEditingController> medicalTeamIdControllers = [TextEditingController()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Incident Form'),
      ),
      body: SingleChildScrollView (
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
                for (int i = 0; i < medicalTeamIdControllers.length; i++)
                  TextFormField(
                    controller: medicalTeamIdControllers[i],
                    decoration: InputDecoration(labelText: 'Doctor ID ${i+1}'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Doctor ID';
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
                          medicalTeamIdControllers.add(TextEditingController());
                        });
                      },
                      child: const Text('Add Field'),
                    ),
                    const SizedBox(width: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (medicalTeamIdControllers.length > 1) {
                            medicalTeamIdControllers.removeLast();
                          }
                        });
                      },
                      child: const Text('Delete Field'),
                    ),
                    const Spacer(),
                  ],
                ),
                TextFormField(
                  controller: incidentController,
                  decoration: const InputDecoration(labelText: 'Incident'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Incident';
                    }
                    return null;
                  },
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
                TextFormField(
                  controller: dateController,
                  decoration: const InputDecoration(labelText: 'Date'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Date';
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
                      submitIncidentData();
                    }
                  },
                  child: const Text('Submit Incident Data'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void submitIncidentData() async {
    try {
      List<UserHasAccess> users = await blockAccessorService.getUsersDoctorHasAccessTo(widget.userID);

      List<int> medicalTeamIds = medicalTeamIdControllers
        .map((controller) => int.parse(controller.text))
        .toList();

      if (!_checkUserID(users, int.parse(userIdController.text))) {
        _showInvalidUserDialog();
      } else if (!await _checkDoctorsID(medicalTeamIds)) {
        _showInvalidDoctorDialog();
      }
      else {
        Incident incidentData = Incident(
          userID: int.parse(userIdController.text),
          medicalTeamIDs: medicalTeamIds,
          incident: incidentController.text,
          description: descriptionController.text,
          date: dateController.text,
          notes: notesController.text,
        );

        await blockWriterService.write(incidentData.userID, incidentData);

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Incident Data submitted successfully!'),
        ));

        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to submit Incident Data.'),
      ));
    }
  }

  bool _checkUserID(List<UserHasAccess> users, int userID) {
    return users.any((user) => user.userID == userID);
  }

  Future<bool>  _checkDoctorsID(List<int> medicalTeamIds) async {
    int ids = medicalTeamIds.length;
    int count = 0;
    List<String> firebaseIDs = [];
    CollectionReference collectionReference = FirebaseFirestore.instance.collection('SocialSec');

    try {
      QuerySnapshot querySnapshot = await collectionReference.where("MedTeam", isEqualTo: true).get();

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        firebaseIDs.add(documentSnapshot.id);
      }

      for (int doctorID in medicalTeamIds) {
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
          content: const Text("Doctor ID not found. Please try again."),
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
}
