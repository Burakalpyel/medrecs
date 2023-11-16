import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medrecs/util/serializables/UserHasAccess.dart';
import '../../util/services/blockWriterService.dart';
import '../../util/serializables/Appointment.dart';
import 'package:medrecs/util/services/blockAccessorService.dart';

class AppointmentFormScreen extends StatefulWidget {
  final int userID;

  const AppointmentFormScreen({Key? key, required this.userID})
      : super(key: key);

  @override
  _AppointmentFormScreenState createState() => _AppointmentFormScreenState();
}

class _AppointmentFormScreenState extends State<AppointmentFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController userIDController = TextEditingController();
  final TextEditingController doctorIDController = TextEditingController();
  final TextEditingController medicalCenterController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment Form'),
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
                  controller: medicalCenterController,
                  decoration:
                      const InputDecoration(labelText: 'Medical Center ID'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Medical Center ID';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: reasonController,
                  decoration: const InputDecoration(labelText: 'Reason'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the reason for the appointment';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: dateController,
                  decoration: const InputDecoration(labelText: 'Date'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the date of the appointment';
                    }
                    // Add any additional validation for the date format if needed
                    return null;
                  },
                ),
                TextFormField(
                  controller: timeController,
                  decoration: const InputDecoration(labelText: 'Time'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the time of the appointment';
                    }
                    // Add any additional validation for the time format if needed
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      submitAppointmentData();
                    }
                  },
                  child: const Text('Submit Appointment Data'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void submitAppointmentData() async {
    try {
      List<UserHasAccess> users =
          await blockAccessorService.getUsersDoctorHasAccessTo(widget.userID);

      if (!_checkUserID(users, int.parse(userIDController.text))) {
        _showErrorDialog("Invalid User ID",
            "That ID doesn't exist or you don't have access. Please try again.");
      } else if (!await _checkDoctorID(doctorIDController.text)) {
        _showErrorDialog(
            "Invalid Doctor ID", "That ID doesn't exist. Please try again.");
      } else {
        Appointment appointmentData = Appointment(
          userID: int.parse(userIDController.text),
          doctorID: int.parse(doctorIDController.text),
          medicalCenter: int.parse(medicalCenterController.text),
          reason: reasonController.text,
          date: dateController.text,
          time: timeController.text,
        );

        // Perform the action to save the appointment data for the original user
        await blockWriterService.write(appointmentData.userID, appointmentData);

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Appointment Data submitted successfully!'),
        ));

        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to submit Appointment Data.'),
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
      QuerySnapshot querySnapshot =
          await collectionReference.where("MedTeam", isEqualTo: true).get();

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
}
