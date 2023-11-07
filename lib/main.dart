import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medrecs/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MedRecs',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LoginScreen(),
    );
  }
}
/*
Widget navBar(BuildContext context) {
  return Scaffold(
      bottomNavigationBar: Container(
      decoration: const BoxDecoration(
      gradient: RadialGradient(
      colors: [
      Color.fromARGB(255, 99, 146, 255),
  Color.fromARGB(255, 218, 218, 218)
  ],
  radius: 10.0,
  ),
  ),
  child: Padding(
  padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
  child: GNav(
  //selectedIndex: _currentIndex,
  gap: 8,
  backgroundColor: Colors.transparent,
  tabBackgroundColor: Color.fromRGBO(255, 255, 255, 0.463),
  color: Colors.black,
  activeColor: Color.fromARGB(255, 0, 21, 255),
  //onTabChange: (index) {
  //             setState(() {
  //    _currentIndex = index;
  //  });
  //         },
  padding: EdgeInsets.all(12.5),
  tabs: const [
  GButton(icon: Icons.home, text: "Home"),
  GButton(icon: Icons.receipt_rounded, text: "Records"),
  GButton(icon: Icons.person_2_rounded, text: "Profile")
  ]),
  ),
  ));
  //body: tabs[_currentIndex],
  // body: Stack(children: <Widget>[buildView(context, _currentIndex)]));
  //buildView(context, _currentIndex));
  }*/
