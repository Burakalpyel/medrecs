import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:medrecs/serializables/iMedicalData.dart';
import 'package:medrecs/services/blockAccessorService.dart';

class HomePage extends StatefulWidget {
  final int userID;
  const HomePage({Key? key, required this.userID}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

final tabs = [
  const Center(child: Text("Home")),
  const Center(child: Text("Records")),
  const Center(child: Text("Profile"))
];

class _HomePageState extends State<HomePage> {
  late List<iMedicalData> entries;

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
        body: Stack(children: <Widget>[buildView(context, _currentIndex)]));
  }

  Widget buildView(BuildContext context, int currIndex) {
    if (currIndex == 1) {
      return buildHistory(context, currIndex);
    }
    return FutureBuilder(
        future: blockAccessorService.getEntries(
            1, blockAccessorService.searchFilterAllTrue()),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasData) {
            return Center(child: Text(snapshot.data[0].summarizeData()));
          } else {
            return const Center(child: Text("Some error occurred."));
          }
        });
  }

  FutureBuilder buildHistory(BuildContext context, int currIndex) {
    return FutureBuilder(
        future: blockAccessorService.getEntries(
            1, blockAccessorService.searchFilterAllTrue()),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasData) {
            entries = snapshot.data;
            int maxLength = entries.length;
            return ListView.builder(
              itemCount: maxLength,
              itemBuilder: (_, index) {
                return Card(
                    child: ExpansionTile(
                        initiallyExpanded: false,
                        title: entries[index].getTitle(),
                        subtitle: entries[index].getSubtitle(),
                        leading: entries[index].getIcon(),
                        trailing: const Icon(Icons.arrow_back_ios_new),
                        children: entries[index].createInfo()));
              },
            );
          } else {
            return const Center(child: Text("Some error occurred."));
          }
        });
  }
}
