import 'package:flutter/material.dart';
import 'package:medrecs/util/serializables/Incident.dart'; // Import the Incident class
import 'package:medrecs/util/services/blockWriterService.dart';

class IncidentFormScreen extends StatefulWidget {
  const IncidentFormScreen({super.key});

  @override
  _IncidentFormScreenState createState() => _IncidentFormScreenState();
}

class _IncidentFormScreenState extends State<IncidentFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController medicalTeamIdsController = TextEditingController();
  final TextEditingController incidentController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Incident Form'),
      ),
      body: Padding(
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
                controller: medicalTeamIdsController,
                decoration: const InputDecoration(labelText: 'Medical Team IDs'),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Medical Team IDs';
                  }
                  return null;
                },
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
    );
  }

  void submitIncidentData() async {
    try {
      var medicalTeamIds = medicalTeamIdsController.text.split(',').map((e) => int.parse(e)).toList();

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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to submit Incident Data.'),
      ));
    }
  }
}
