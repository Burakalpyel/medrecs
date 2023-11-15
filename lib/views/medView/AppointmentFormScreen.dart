import 'package:flutter/material.dart';
import '../../util/services/blockWriterService.dart';
import '../../util/serializables/Appointment.dart';

class AppointmentFormScreen extends StatefulWidget {
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
        title: Text('Appointment Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: userIDController,
                decoration: InputDecoration(labelText: 'User ID'),
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
                decoration: InputDecoration(labelText: 'Doctor ID'),
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
                decoration: InputDecoration(labelText: 'Medical Center ID'),
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
                decoration: InputDecoration(labelText: 'Reason'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the reason for the appointment';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: dateController,
                decoration: InputDecoration(labelText: 'Date'),
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
                decoration: InputDecoration(labelText: 'Time'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the time of the appointment';
                  }
                  // Add any additional validation for the time format if needed
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    submitAppointmentData();
                  }
                },
                child: Text('Submit Appointment Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void submitAppointmentData() async {
    try {
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

      // Send the same appointment data with inverted userID and doctorID for the other user
      Appointment invertedAppointmentData = Appointment(
        userID: appointmentData.doctorID,
        doctorID: appointmentData.userID,
        medicalCenter: appointmentData.medicalCenter,
        reason: appointmentData.reason,
        date: appointmentData.date,
        time: appointmentData.time,
      );

      // Perform the action to save the appointment data for the other user
      await blockWriterService.write(invertedAppointmentData.userID, invertedAppointmentData);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Appointment Data submitted successfully!'),
      ));

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to submit Appointment Data.'),
      ));
    }
  }

}
