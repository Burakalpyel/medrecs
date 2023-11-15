import 'package:flutter/material.dart';
import 'AllergyFormScreen.dart';
import 'DrugFormScreen.dart';
import 'IncidentFormScreen.dart';
import 'InjuryFormScreen.dart';
import 'SurgeryFormScreen.dart';

class DoctorFormScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Form'),
        elevation: 0, // Remove app bar elevation
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              MedicalDataButton(
                label: 'Allergy',
                onPressed: () {
                  navigateToMedicalDataForm(context, AllergyFormScreen());
                },
                theme: theme,
              ),
              SizedBox(height: 16),
              MedicalDataButton(
                label: 'Drug',
                onPressed: () {
                  navigateToMedicalDataForm(context, DrugFormScreen());
                },
                theme: theme,
              ),
              SizedBox(height: 16),
              MedicalDataButton(
                label: 'Incident',
                onPressed: () {
                  navigateToMedicalDataForm(context, IncidentFormScreen());
                },
                theme: theme,
              ),
              SizedBox(height: 16),
              MedicalDataButton(
                label: 'Injury',
                onPressed: () {
                  navigateToMedicalDataForm(context, InjuryFormScreen());
                },
                theme: theme,
              ),
              SizedBox(height: 16),
              MedicalDataButton(
                label: 'Surgery',
                onPressed: () {
                  navigateToMedicalDataForm(context, SurgeryFormScreen());
                },
                theme: theme,
              ),
            ],
          ),
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
  final ThemeData theme;

  const MedicalDataButton({
    required this.label,
    required this.onPressed,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        primary: theme.primaryColor, // Use the primary color from the theme
        onPrimary: Colors.white,
        padding: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
