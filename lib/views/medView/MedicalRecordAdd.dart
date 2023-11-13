import 'package:flutter/material.dart';
import 'package:medrecs/util/serializables/Allergy.dart';
import 'package:medrecs/util/serializables/Drug.dart';
import 'package:medrecs/util/serializables/Incident.dart';
import 'package:medrecs/util/serializables/Injury.dart';
import 'package:medrecs/util/serializables/Surgery.dart';

import 'AllergyFormScreen.dart';
import 'DrugFormScreen.dart';
import 'IncidentFormScreen.dart';
import 'InjuryFormScreen.dart';
import 'SurgeryFormScreen.dart';

class DoctorFormScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            MedicalDataButton(
              label: 'Allergy',
              onPressed: () {
                navigateToMedicalDataForm(context, AllergyFormScreen());
              },
            ),
            MedicalDataButton(
              label: 'Drug',
              onPressed: () {
                navigateToMedicalDataForm(context, DrugFormScreen());
              },
            ),
            MedicalDataButton(
              label: 'Incident',
              onPressed: () {
                navigateToMedicalDataForm(context, IncidentFormScreen());
              },
            ),
            MedicalDataButton(
              label: 'Injury',
              onPressed: () {
                navigateToMedicalDataForm(context, InjuryFormScreen());
              },
            ),
            MedicalDataButton(
              label: 'Surgery',
              onPressed: () {
                navigateToMedicalDataForm(context, SurgeryFormScreen());
              },
            ),
          ],
        ),
      ),
    );
  }

  void navigateToMedicalDataForm(BuildContext context, Widget formScreen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => formScreen),
    );
  }
}

class MedicalDataButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const MedicalDataButton({
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }
}