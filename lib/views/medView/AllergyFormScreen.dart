import 'package:flutter/material.dart';
import 'package:medrecs/util/serializables/Allergy.dart';
import 'package:medrecs/util/serializables/UserHasAccess.dart';
import 'package:medrecs/util/services/blockWriterService.dart';
import 'package:medrecs/util/services/blockAccessorService.dart';

class AllergyFormScreen extends StatefulWidget {
  final int userID;

  const AllergyFormScreen({Key? key, required this.userID})
      : super(key: key);

  @override
  _AllergyFormScreenState createState() => _AllergyFormScreenState();
}

class _AllergyFormScreenState extends State<AllergyFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController allergyController = TextEditingController();
  final TextEditingController dateOfDiscoveryController = TextEditingController();
  final TextEditingController treatmentController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Allergy Form'),
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
                  controller: allergyController,
                  decoration: const InputDecoration(labelText: 'Allergy'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Allergy';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: dateOfDiscoveryController,
                  decoration: const InputDecoration(labelText: 'Date of Discovery'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Date of Discovery';
                    }
                    // Add any additional validation for the date format if needed
                    return null;
                  },
                ),
                TextFormField(
                  controller: treatmentController,
                  decoration: const InputDecoration(labelText: 'Treatment'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Treatment';
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
                      submitAllergyData();
                    }
                  },
                  child: const Text('Submit Allergy Data'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void submitAllergyData() async {

    try {
      List<UserHasAccess> users = await blockAccessorService.getUsersDoctorHasAccessTo(widget.userID);

      if (_checkUserID(users, int.parse(userIdController.text))) {
        Allergy allergyData = Allergy(
          userID: int.parse(userIdController.text),
          allergy: allergyController.text,
          dateOfDiscovery: dateOfDiscoveryController.text,
          treatment: treatmentController.text,
          notes: notesController.text,
        );

        await blockWriterService.write(allergyData.userID, allergyData);

        // Handle success, e.g., show a success message
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Allergy Data submitted successfully!'),
        ));

        // Navigate back to the previous screen
        Navigator.pop(context);

      } else _showInvalidUserDialog();
    } catch (e) {
      // Handle errors, e.g., show an error message
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to submit Allergy Data.'),
      ));
    }
  }

  bool _checkUserID(List<UserHasAccess> users, int userID) {
    return users.any((user) => user.userID == userID);
  }
  
  void _showInvalidUserDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Invalid User ID'),
          content: const Text("You don't have access to that ID. Please try again."),
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

