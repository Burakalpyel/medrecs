import 'package:flutter/material.dart';
import 'package:medrecs/util/serializables/SETTINGS.dart';
import 'package:medrecs/util/serializables/iMedicalData.dart';
import 'package:medrecs/util/serializables/Surgery.dart'; // Import the Surgery class
import 'package:medrecs/util/services/blockWriterService.dart';

class SurgeryFormScreen extends StatefulWidget {
  @override
  _SurgeryFormScreenState createState() => _SurgeryFormScreenState();
}

class _SurgeryFormScreenState extends State<SurgeryFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController surgeryNameController = TextEditingController();
  final TextEditingController hospitalIdController = TextEditingController();
  final TextEditingController surgeonTeamIdsController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Surgery Form'),
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
                controller: surgeryNameController,
                decoration: InputDecoration(labelText: 'Surgery Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Surgery Name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: hospitalIdController,
                decoration: InputDecoration(labelText: 'Hospital ID'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Hospital ID';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: surgeonTeamIdsController,
                decoration: InputDecoration(labelText: 'Surgeon Team IDs'),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Surgeon Team IDs';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: dateController,
                decoration: InputDecoration(labelText: 'Date'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Date';
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
                    submitSurgeryData();
                  }
                },
                child: Text('Submit Surgery Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void submitSurgeryData() async {
    try {
      var surgeonTeamIds = surgeonTeamIdsController.text.split(',').map((e) => int.parse(e)).toList();

      Surgery surgeryData = Surgery(
        userID: int.parse(userIdController.text),
        surgeryName: surgeryNameController.text,
        hospitalID: int.parse(hospitalIdController.text),
        surgeonTeamIDs: surgeonTeamIds,
        description: descriptionController.text,
        date: dateController.text,
        notes: notesController.text,
      );

      await blockWriterService.write(surgeryData.userID, surgeryData);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Surgery Data submitted successfully!'),
      ));

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to submit Surgery Data.'),
      ));
    }
  }
}
