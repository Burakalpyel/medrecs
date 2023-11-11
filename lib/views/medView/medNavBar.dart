import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:medrecs/util/model/patientinfo.dart';
import 'package:medrecs/util/serializables/iMedicalData.dart';
import 'package:medrecs/views/medView/ProfileMedPage.dart';
import 'package:medrecs/views/userView/Dashboard.dart';
import 'package:medrecs/views/userView/RecordsPage.dart';

class medNavBar extends StatefulWidget {
  final int userID;
  PatientInfo userInfo;
  medNavBar({Key? key, required this.userID, required this.userInfo})
      : super(key: key);
  @override
  State<medNavBar> createState() => _HomePageState();
}

final tabs = [
  const Center(child: Text("Home")),
  const Center(child: Text("Records")),
  const Center(child: Text("Profile"))
];

class _HomePageState extends State<medNavBar> {
  List<String> pageKeys = ["Page1", "Page2", "Page3"];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
                selectedIndex: _currentIndex,
                gap: 8,
                backgroundColor: Colors.transparent,
                tabBackgroundColor: const Color.fromRGBO(255, 255, 255, 0.463),
                color: Colors.black,
                activeColor: const Color.fromARGB(255, 0, 21, 255),
                onTabChange: (index) {
                  if (_currentIndex != index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  }
                },
                padding: const EdgeInsets.all(12.5),
                tabs: const [
                  GButton(icon: Icons.home, text: "Home"),
                  GButton(icon: Icons.receipt_rounded, text: "Records"),
                  GButton(icon: Icons.person_2_rounded, text: "Profile")
                ]),
          ),
        ),
        body: Stack(children: <Widget>[buildView(context, _currentIndex)]));
  }

  Widget buildView(BuildContext context, int currIndex) {
    if (currIndex == 0) {
      return Dashboard(userID: widget.userID, userInfo: widget.userInfo);
    } else if (currIndex == 1) {
      return RecordsPage(userID: widget.userID);
    }
    return ProfileMedPage(userID: widget.userID, userInfo: widget.userInfo);
  }

  List<List<dynamic>> formatData(List<iMedicalData> list) {
    List<List<dynamic>> retList = [];
    for (iMedicalData temp in list) {
      retList.add([temp.getType(), temp]);
    }
    return retList;
  }
}
