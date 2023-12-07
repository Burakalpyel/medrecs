import 'package:flutter/material.dart';
import 'package:medrecs/util/model/patientinfo.dart';
import 'package:medrecs/util/model/user_data.dart';
import 'package:medrecs/util/services/login_service.dart';
import 'package:medrecs/views/medView/MedTeamScreen.dart';
import 'package:medrecs/views/userView/userNavBar.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _userIDController = TextEditingController();

  void showInvalidPasswordDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Invalid Password'),
          content: const Text('The password is incorrect. Please try again.'),
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

  void showEmptyFieldDialog() {
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
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  bool _passwordValidation(String input, String password) {
    return input == password;
  }

  bool _userValidation(String input, String user) {
    return input == user;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
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
                          loginService collector = loginService();
                          PatientInfo? user = await collector
                              .retrieveSocialSec(_userIDController.text);

                          String enteredPassword = _passwordController.text;
                          String enteredUserID = _userIDController.text;

                          // Check for empty fields
                          if (enteredPassword.isEmpty || enteredUserID.isEmpty) {
                            showEmptyFieldDialog();
                          } else {
                            // Validate the entered password
                            if (!_passwordValidation(enteredPassword, user!.password)) {
                              // Invalid password, show an alert dialog
                              showInvalidPasswordDialog();
                            } else {
                              var userData = Provider.of<UserData>(context, listen: false);
                              userData.updateUserInfo(user);
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => user.medteamstatus
                                    ? MedTeamScreen(
                                        userID: int.parse(enteredUserID),
                                        userInfo: user,
                                      )
                                    : userNavBar(
                                        userID: int.parse(enteredUserID),
                                      ),
                              ));
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: theme.colorScheme.onPrimary,
                          backgroundColor: theme.primaryColor,
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
      )
    );
  }
}
