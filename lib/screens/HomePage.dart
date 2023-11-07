import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  final int userID;
  const HomePage({Key? key, required this.userID}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

final tabs = [
  Center(child: Text("Home")),
  Center(child: Text("Records")),
  Center(child: Text("Profile"))
];

class _HomePageState extends State<HomePage> {
  String _currentPage = "Page1";
  List<String> pageKeys = ["Page1", "Page2", "Page3"];
  Map<String, GlobalKey<NavigatorState>> _navigatorKeys = {
    "Page1": GlobalKey<NavigatorState>(),
    "Page2": GlobalKey<NavigatorState>(),
    "Page3": GlobalKey<NavigatorState>(),
  };
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
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
                selectedIndex: _currentIndex,
                gap: 8,
                backgroundColor: Colors.transparent,
                tabBackgroundColor: Color.fromRGBO(255, 255, 255, 0.463),
                color: Colors.black,
                activeColor: Color.fromARGB(255, 0, 21, 255),
                onTabChange: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                padding: EdgeInsets.all(12.5),
                tabs: const [
                  GButton(icon: Icons.home, text: "Home"),
                  GButton(icon: Icons.receipt_rounded, text: "Records"),
                  GButton(icon: Icons.person_2_rounded, text: "Profile")
                ]),
          ),
        ),
        //body: tabs[_currentIndex],
        body: Stack(children: <Widget>[buildView(context, _currentIndex)]));
    //buildView(context, _currentIndex));
  }

  Widget buildView(BuildContext context, int currIndex) {
    if (currIndex == 1) {
      return buildHistory(context, currIndex);
    }
    return Center(child: Text("HELLO"));
  }

  ListView buildHistory(BuildContext context, int currIndex) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (_, index) {
        return Card(
            child: ExpansionTile(
                initiallyExpanded: false,
                title: Text("The list item #$index"),
                subtitle: Text("The subtitle"),
                leading: Icon(Icons.personal_injury),
                trailing: IconButton(
                  icon: Icon(Icons.arrow_back_ios_new),
                  onPressed: () {},
                ),
                children: <Widget>[
              ListTile(title: Text("LOADING")),
              ListTile(title: Text("LOADING")),
            ]));
      },
    );
  }

  Future<List<Widget>> createEntries(BuildContext context, int userID) async {
    var queryParameters = {
      "surgery": true,
      "userHasAccess": true,
      "injury": true,
      "incident": true,
      "drug": true,
      "appointment": true,
      "allergy": true
    };
    var uri = Uri.http('localhost:5000', '/data/1', queryParameters);
    var headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    var response = await http.get(uri, headers: headers);
    return <Widget>[
      ListTile(title: Text(response as String)),
    ];
  }
}
