import 'package:flutter/material.dart';
import 'package:medrecs/util/serializables/SETTINGS.dart';
import 'package:medrecs/util/serializables/iReminderData.dart';
import 'package:medrecs/util/serializables/Drug.dart'; // Import the Drug class
import 'package:medrecs/util/services/blockWriterService.dart';

class DrugFormScreen extends StatefulWidget {
  @override
  _DrugFormScreenState createState() => _DrugFormScreenState();
}

class _DrugFormScreenState extends State<DrugFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController doctorIdController = TextEditingController();
  final TextEditingController drugController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Drug Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: userIdController,
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
                controller: doctorIdController,
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
                controller: drugController,
                decoration: InputDecoration(labelText: 'Drug'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Drug';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: startDateController,
                decoration: InputDecoration(labelText: 'Start Date'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Start Date';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: endDateController,
                decoration: InputDecoration(labelText: 'End Date'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter End Date';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: reasonController,
                decoration: InputDecoration(labelText: 'Reason'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Reason';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: notesController,
                decoration: InputDecoration(labelText: 'Notes'),
                // You can leave this field empty
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    submitDrugData();
                  }
                },
                child: Text('Submit Drug Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void submitDrugData() async {
    try {
      Drug drugData = Drug(
        userID: int.parse(userIdController.text),
        doctorID: int.parse(doctorIdController.text),
        drug: drugController.text,
        startDate: startDateController.text,
        endDate: endDateController.text,
        reason: reasonController.text,
        notes: notesController.text,
      );

      await blockWriterService.write(drugData.userID, drugData);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Drug Data submitted successfully!'),
      ));

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to submit Drug Data.'),
      ));
    }
  }
}
