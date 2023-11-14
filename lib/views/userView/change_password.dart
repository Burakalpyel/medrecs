import 'package:flutter/material.dart';
import 'package:medrecs/util/model/patientinfo.dart';
import 'package:medrecs/util/model/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class ChangePassword extends StatefulWidget {
  final int userID;

  const ChangePassword({Key? key, required this.userID})
      : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _repeatController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var userData = Provider.of<UserData>(context);
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "EDIT DETAILS",
          style: TextStyle(
            color: theme.colorScheme.onPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold)
        ),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height:10),
              TextFormField(
                controller: _oldPasswordController,
                obscureText: true,
                decoration: myInputDecoration("Old Password"),
              ),
              const SizedBox(height:15),
              TextFormField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: myInputDecoration("New Password"),
              ),
              const SizedBox(height:15),
              TextFormField(
                controller: _repeatController,
                obscureText: true,
                decoration: myInputDecoration("Repeat the Password"),
              ),
              const SizedBox(height:25),
              ElevatedButton(
                onPressed: () {
                  String oldPassword = _oldPasswordController.text;
                  String newPassword = _newPasswordController.text;
                  String repeatPassword = _repeatController.text;

                  if (oldPassword.isEmpty || newPassword.isEmpty || repeatPassword.isEmpty) {
                    _showEmptyFieldDialog();
                  } else if (oldPassword != userData.userInfo.password) {
                    _showInvalidPasswordDialog("The old password is incorrect. Please try again");
                  } else if (newPassword != repeatPassword) {
                    _showInvalidPasswordDialog("There was a mitmach in your new password. Please try again");
                  } else {
                    updateData(newPassword);
                  }
                }, 
                style: ElevatedButton.styleFrom(
                  foregroundColor: theme.colorScheme.onPrimary,
                  backgroundColor: theme.colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                )
              ),
            ],
          ),
        ),
      )
    );
  }
  
  InputDecoration myInputDecoration(String labelText) {
    ThemeData theme = Theme.of(context);
    return InputDecoration(
      labelText: labelText,
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: theme.colorScheme.primary,
          width: 2.0,
        ),
      ),
      labelStyle: TextStyle(
        color: theme.colorScheme.primary, // Adjust the color here
      ),
    );
  }

  void updateData(String newPassword) async {
    var userData = Provider.of<UserData>(context, listen: false);

    DocumentReference documentReference = FirebaseFirestore.instance.collection('SocialSec').doc(widget.userID.toString());

    try {
      // Update the data in firebase
      await documentReference.update({
        'Password': newPassword
      });
      debugPrint("Data updated successfully");
    } catch (e) {
      debugPrint("Error updating data: $e");
      return;
    }

    PatientInfo userInfo = PatientInfo(
        name: userData.userInfo.name,
        surname: userData.userInfo.surname,
        birthday: userData.userInfo.birthday,
        address: userData.userInfo.address,
        phone: userData.userInfo.phone,
        location: userData.userInfo.location,
        medteamstatus: userData.userInfo.medteamstatus,
        password: newPassword,
    );

    Navigator.pop(context, userInfo);
  }
  
  void _showInvalidPasswordDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Invalid Password'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showEmptyFieldDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Empty Fields'),
          content:
              const Text('Please fill in all the fields.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}