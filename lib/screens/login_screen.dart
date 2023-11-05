import 'package:flutter/material.dart';
import '../password/passwordinfo.dart';
import 'patientinfo_screen.dart'; // Import the PatientInfoScreen file.

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 400, // Increase the height to make the logo larger
              child: Image.asset('images/4.png',
                  height: 300), // Adjust the height as needed
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
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        // Get the password entered by the user
                        String enteredPassword = _passwordController.text;
                        // Validate the entered password
                        if (checkIfPasswordValid(int.parse(enteredPassword))) {
                          // Password is valid, navigate to PatientInfoScreen
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const PatientInfoScreen(),
                            ),
                          );
                        } else {
                          // Invalid password, show an error message or handle it as needed
                          // TODO create an alert(Pop-Up) instead of print
                          print('Invalid password. Please try again.');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.purple, // Change button color to purple
                        onPrimary: Colors.white, // Change text color to white
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
