import 'package:flutter/material.dart';
import 'package:medrecs/util/model/patientinfo.dart';
import 'package:medrecs/util/services/patientinfo_service.dart';

class SettingsScreen extends StatefulWidget {
  final int userID;
  final PatientInfo userInfo;

  const SettingsScreen({Key? key, required this.userID, required this.userInfo})
      : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  patientInfoService collector = patientInfoService();
  bool notificationSwitchValue = true; // Sample setting

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "SETTINGS",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue[800],
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Edit profile'),
            leading: Icon(Icons.edit),
            onTap: () {
              // Handle the tap event for the Notifications tile
            },
          ),
          ListTile(
            title: Text('Theme'),
            leading: Icon(Icons.brightness_4),
            onTap: () {
              // Handle the tap event for the Dark Mode tile
            },
          ),
          ListTile(
            title: Text('Language'),
            leading: Icon(Icons.language),
            onTap: () {
              // Handle the tap event for the Dark Mode tile
            },
          ),
          ListTile(
            title: Text('Change Password'),
            leading: Icon(Icons.lock),
            onTap: () {
              // Handle the tap event for the Dark Mode tile
            },
          ),
          ListTile(
            title: Text('Log out'),
            leading: Icon(Icons.logout),
            onTap: () {
              // Handle the tap event for the Dark Mode tile
            },
          ),
        ],
      ),
    );
  }
}
