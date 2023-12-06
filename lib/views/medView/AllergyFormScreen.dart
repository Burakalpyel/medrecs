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
  DateTime? selectedDate;

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
                  key: Key('user_id_input'),
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
                  key: Key('allergy_input'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Allergy';
                    }
                    return null;
                  },
                ),
                // Date Picker
                InkWell(
                  key: Key('date_picker'),
                  onTap: () {
                    _selectDate(context);
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Date of Discovery',
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
                  controller: treatmentController,
                  decoration: const InputDecoration(labelText: 'Treatment'),
                  key: Key('treatment_input'),
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
                  key: Key('submit_button'),
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
      List<UserHasAccess> users =
      await blockAccessorService.getUsersDoctorHasAccessTo(widget.userID);

      if (_checkUserID(users, int.parse(userIdController.text))) {
        Allergy allergyData = Allergy(
          userID: int.parse(userIdController.text),
          allergy: allergyController.text,
          dateOfDiscovery: dateOfDiscoveryController.text,
          treatment: treatmentController.text,
          notes: notesController.text,
        );

        await blockWriterService.write(allergyData.userID, allergyData);

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          key: Key('confirm_key'),
          content: Text('Allergy Data submitted successfully!'),
        ));

        Navigator.pop(context);
      } else {
        _showInvalidUserDialog();
      }
    } catch (e) {
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
        dateOfDiscoveryController.text = pickedDate.toLocal().toString().split(' ')[0];
      });
    }
  }
}
