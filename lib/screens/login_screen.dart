import 'package:flutter/material.dart';
import 'package:medrecs/screens/HomePage.dart';
import '../bd/patientinfocollector.dart';
import '../model/patientinfo.dart';
import '../password/passwordinfo.dart';
import 'MedTeamScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _userIDController = TextEditingController();

  void _showInvalidPasswordDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Invalid Password'),
          content: const Text('The password is incorrect. Please try again.'),
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
              const Text('Please fill in both UserID and Password fields.'),
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

  bool PasswordValidation(String input, String password) {
    if (input == password) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 400,
              child: Image.asset('images/4.png', height: 300),
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: _userIDController,
                      decoration: InputDecoration(
                        labelText: 'UserID',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 200,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () async {
                        // Get the password and UserID entered by the user
                        PatientInfoCollector collector = PatientInfoCollector();
                        PatientInfo? user = await collector.retrieveSocialSec(_userIDController.text);

                        String enteredPassword = _passwordController.text;
                        String enteredUserID = _userIDController.text;

                        // Check for empty fields
                        if (enteredPassword.isEmpty || enteredUserID.isEmpty) {
                          _showEmptyFieldDialog();
                        } else {
                          // Validate the entered password
                          if (!PasswordValidation(enteredPassword, user!.password)) {
                            // Invalid password, show an alert dialog
                            _showInvalidPasswordDialog();
                          } else {
                            Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => user!.medteamstatus
                                      ? MedTeamScreen(
                                    userID: int.parse(enteredUserID),
                                  )
                                      : HomePage(
                                    userID: int.parse(enteredUserID),
                                  ),
                                ));
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.purple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
