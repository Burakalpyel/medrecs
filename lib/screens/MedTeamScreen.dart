import 'package:flutter/material.dart';

class MedTeamScreen extends StatefulWidget {
  final int userID;
  MedTeamScreen({Key? key, required this.userID}) : super(key: key);
  @override
  _MedTeamScreenState createState() => _MedTeamScreenState();
}

class _MedTeamScreenState extends State<MedTeamScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MedTeam Screen"),
      ),
      body: Column(
        children: <Widget>[
          // Add Medical Records
          ListTile(
            leading: Icon(Icons.receipt_rounded),
            title: Text("Add Medical Record"),
            onTap: () {
              // Implement logic to add medical records
            },
          ),
          Divider(),

          // Add Appointments
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text("Add Appointment"),
            onTap: () {
              // Implement logic to add appointments
            },
          ),
          Divider(),

          // Add Reminders
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text("Add Reminder"),
            onTap: () {
              // Implement logic to add reminders
            },
          ),
        ],
      ),
    );
  }
}
