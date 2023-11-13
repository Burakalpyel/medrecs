import 'package:flutter/material.dart';
import 'package:medrecs/util/model/patientinfo.dart';
import 'package:medrecs/util/model/user_data.dart';
import 'package:medrecs/util/services/patientinfo_service.dart';
import 'package:medrecs/views/userView/change_password.dart';
import 'package:medrecs/views/userView/edit_profile.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  final int userID;

  const SettingsScreen({Key? key, required this.userID})
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
              navigateToEditProfile();
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
            title: Text('Change password'),
            leading: Icon(Icons.lock),
            onTap: () {
              navigateToChangePassword();
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
    
  void navigateToEditProfile() async {
    // Navigate to the second page and await the result
    PatientInfo? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfile(
          userID: widget.userID,
        ),
      ),
    );

    if (result != null) {
      // Update the user information in the UserData provider
      Provider.of<UserData>(context, listen: false).updateUserInfo(result);
    }
  }
    
  void navigateToChangePassword() async {
    // Navigate to the second page and await the result
    PatientInfo? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangePassword(
          userID: widget.userID,
        ),
      ),
    );

    if (result != null) {
      // Update the user information in the UserData provider
      Provider.of<UserData>(context, listen: false).updateUserInfo(result);
    }
  }
}
