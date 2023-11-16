import 'package:flutter/material.dart';
import 'AllergyFormScreen.dart';
import 'DrugFormScreen.dart';
import 'IncidentFormScreen.dart';
import 'InjuryFormScreen.dart';
import 'SurgeryFormScreen.dart';

class DoctorFormScreen extends StatelessWidget {
  const DoctorFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Form'),
        elevation: 0, // Remove app bar elevation
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'What would you like to add?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              MedicalDataButton(
                label: 'Allergy',
                onPressed: () {
                  navigateToMedicalDataForm(context, const AllergyFormScreen());
                },
                theme: theme,
              ),
              const SizedBox(height: 16),
              MedicalDataButton(
                label: 'Drug',
                onPressed: () {
                  navigateToMedicalDataForm(context, const DrugFormScreen());
                },
                theme: theme,
              ),
              const SizedBox(height: 16),
              MedicalDataButton(
                label: 'Incident',
                onPressed: () {
                  navigateToMedicalDataForm(context, const IncidentFormScreen());
                },
                theme: theme,
              ),
              const SizedBox(height: 16),
              MedicalDataButton(
                label: 'Injury',
                onPressed: () {
                  navigateToMedicalDataForm(context, const InjuryFormScreen());
                },
                theme: theme,
              ),
              const SizedBox(height: 16),
              MedicalDataButton(
                label: 'Surgery',
                onPressed: () {
                  navigateToMedicalDataForm(context, const SurgeryFormScreen());
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

  const MedicalDataButton({super.key, 
    required this.label,
    required this.onPressed,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: theme.primaryColor,
        padding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
