import 'package:flutter/material.dart';
import 'package:medrecs/util/model/patientinfo.dart';
import 'package:medrecs/util/model/theme_model.dart';
import 'package:medrecs/util/model/user_data.dart';
import 'package:medrecs/util/services/patientinfo_service.dart';
import 'package:medrecs/views/userView/change_password.dart';
import 'package:medrecs/views/userView/change_theme.dart';
import 'package:medrecs/views/userView/edit_profile.dart';
import 'package:medrecs/views/userView/login_screen.dart';
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
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "SETTINGS",
          style: TextStyle(
            color: theme.colorScheme.onPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: theme.colorScheme.primary,
        iconTheme: IconThemeData(
          color: theme.colorScheme.onPrimary,
        ),
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('Edit profile'),
            leading: const Icon(Icons.edit),
            onTap: () {
              navigateToEditProfile();
            },
          ),
          ListTile(
            title: const Text('Theme'),
            leading: const Icon(Icons.brightness_4),
            onTap: () {
              navigateToChangeTheme();
            },
          ),
          ListTile(
            title: const Text('Change password'),
            leading: const Icon(Icons.lock),
            onTap: () {
              navigateToChangePassword();
            },
          ),
          ListTile(
            title: const Text('Log out'),
            leading: const Icon(Icons.logout),
            onTap: () async {
              await Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => const LoginScreen()));
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
    
  void navigateToChangeTheme() async {
    // Navigate to the second page and await the result
    Color? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChangeTheme(),
      ),
    );

    if (result != null) {
      // Update the user information in the UserData provider
      Provider.of<ThemeModel>(context, listen: false).updateTheme(ThemeData(colorSchemeSeed: result),
    );
    }
  }
}