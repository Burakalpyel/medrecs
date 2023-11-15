import 'package:flutter/material.dart';
import 'package:medrecs/util/serializables/SETTINGS.dart';
import 'package:medrecs/util/serializables/iMedicalData.dart';
import 'package:medrecs/util/serializables/Injury.dart'; // Import the Injury class
import 'package:medrecs/util/services/blockWriterService.dart';

class InjuryFormScreen extends StatefulWidget {
  @override
  _InjuryFormScreenState createState() => _InjuryFormScreenState();
}

class _InjuryFormScreenState extends State<InjuryFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController medicalTeamIdsController = TextEditingController();
  final TextEditingController injuryController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Injury Form'),
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
                controller: medicalTeamIdsController,
                decoration: InputDecoration(labelText: 'Medical Team IDs'),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Medical Team IDs';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: injuryController,
                decoration: InputDecoration(labelText: 'Injury'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Injury';
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
                    submitInjuryData();
                  }
                },
                child: Text('Submit Injury Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void submitInjuryData() async {
    try {
      var medicalTeamIds = medicalTeamIdsController.text.split(',').map((e) => int.parse(e)).toList();

      Injury injuryData = Injury(
        userID: int.parse(userIdController.text),
        medicalTeamIDs: medicalTeamIds,
        injury: injuryController.text,
        description: descriptionController.text,
        date: dateController.text,
        notes: notesController.text,
      );

      await blockWriterService.write(injuryData.userID, injuryData);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Injury Data submitted successfully!'),
      ));

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to submit Injury Data.'),
      ));
    }
  }
}
