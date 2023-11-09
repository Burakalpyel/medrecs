import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:medrecs/util/serializables/iMedicalData.dart';
import 'package:medrecs/util/serializables/iReminderData.dart';
import 'package:medrecs/util/services/blockAccessorService.dart';
import 'package:medrecs/views/userView/ProfilePage.dart';

class UserHomePage extends StatefulWidget {
  final int userID;
  UserHomePage({Key? key, required this.userID}) : super(key: key);
  @override
  State<UserHomePage> createState() => _HomePageState();
}

final tabs = [
  const Center(child: Text("Home")),
  const Center(child: Text("Records")),
  const Center(child: Text("Profile"))
];

class _HomePageState extends State<UserHomePage> {
  List<String> pageKeys = ["Page1", "Page2", "Page3"];
  List<bool> filters = [true, true, true, true, true, true, true];
  int _currentIndex = 0;
  late List<iMedicalData> entries;

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
    if (currIndex == 1) {
      return buildRecordBrowser(context);
    } else if (currIndex == 0) {
      return buildHomePage(context);
    } else if (currIndex == 2) {
      return ProfilePage(userID: widget.userID.toString());
    } else {
      return FutureBuilder(
          future: blockAccessorService.getEntries(
              widget.userID, blockAccessorService.searchFilterAllTrue()),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return Center(child: Text(snapshot.data[0].summarizeData()));
            } else {
              return const Center(child: Text("Some error occurred."));
            }
          });
    }
  }

  FutureBuilder buildHomePage(BuildContext context) {
    return FutureBuilder(
        future: blockAccessorService.getReminderEntries(widget.userID),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: const CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            entries = snapshot.data;
            return Scaffold(
              backgroundColor: Colors.blue[800],
              body: SafeArea(
                child: Column(
                  children: [
                    getHomeHeaders(),
                    const SizedBox(
                      height: 10,
                    ),
                    getHomeReminders(snapshot.data as List<iReminderData>)
                  ],
                ),
              ),
            );
          } else {
            return const Center(
                child: Text("Unable to connect to the servers."));
          }
        });
  }

  Expanded getHomeReminders(List<iReminderData> reminderData) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(25),
        color: Colors.grey[200],
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: buildReminders(reminderData),
            ),
          ),
        ),
      ),
    );
  }

  Padding getHomeHeaders() {
    return Padding(
      padding: const EdgeInsets.only(top: 25.0, left: 25.0, right: 25.0),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Hi " + "USER " + "NAME!",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text('23 Jan, 2023',
                    style: TextStyle(
                      color: Colors.blue[200],
                    ))
              ],
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.blue[600],
                  borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.all(12),
              child: const Icon(
                Icons.medical_information,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 25,
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.emoji_people_sharp,
              color: Colors.white,
            ),
            Text(
              "How do you feel?",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ]),
    );
  }

  List<Widget> buildReminders(List<iReminderData> reminderData) {
    List<Widget> list = [];
    int count = 0;
    list.add(const Row(children: [
      Text(
        "Relevant Reminders",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      Icon(Icons.notifications)
    ]));

    for (iReminderData tempData in reminderData) {
      if (count == 5) {
        return list;
      }
      list.add(const SizedBox(
        height: 15,
      ));
      list.add(Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: ListTile(
          leading: tempData.getReminderIcon(),
          title: tempData.getReminderTitle(),
          subtitle: tempData.getReminderSubtitle(),
        ),
      ));
      count++;
    }

    if (count < 5) {
      if (count < 4) {
        if (count == 0) {
          list.add(const SizedBox(
            height: 15,
          ));
          list.add(Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: const ListTile(
              leading: Icon(Icons.notifications_off),
              title: Text("No available reminders",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              subtitle: Text("You seem to be in good shape!",
                  style: TextStyle(fontSize: 16)),
            ),
          ));
        }
        list.add(const SizedBox(
          height: 15,
        ));
        list.add(Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: const ListTile(
            leading: Icon(Icons.info),
            title: Text(
                "Press the top-right buttom on your next visit to the doctor",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            subtitle: Text(
                "Use it to give Medical Staff access to your records.",
                style: TextStyle(fontSize: 16)),
          ),
        ));
      }
      list.add(const SizedBox(
        height: 15,
      ));
      list.add(Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: const ListTile(
          leading: Icon(Icons.safety_check),
          title: Text("Do NOT share your passwords",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          subtitle: Text(
              "Keep your personal data safe!\nWe will NOT ask for your password",
              style: TextStyle(fontSize: 16)),
        ),
      ));
    }

    return list;
  }

  FutureBuilder buildRecordBrowser(BuildContext context) {
    return FutureBuilder(
        future: blockAccessorService.getEntries(
            widget.userID, blockAccessorService.searchFilter(filters)),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: const CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            entries = snapshot.data;
            return Scaffold(
              appBar: AppBar(
                  title: const Center(
                      child: Text("MEDICAL RECORDS",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ))),
                  backgroundColor: Colors.white,
                  automaticallyImplyLeading: false),
              body: Column(
                children: [
                  Center(
                      child: ExpansionTile(
                    initiallyExpanded: false,
                    backgroundColor: const Color.fromRGBO(219, 219, 219, 1),
                    title: const Text(
                      "Filters",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    children: <Widget>[
                      generateFilters(),
                    ],
                  )),
                  Expanded(
                      child: Container(
                    padding: const EdgeInsets.all(20),
                    child: ListView.builder(
                      itemCount: entries.length,
                      itemBuilder: (_, index) {
                        return Card(
                            color: Colors.blue,
                            elevation: 4,
                            child: ExpansionTile(
                                initiallyExpanded: false,
                                title: entries[index].getTitle(),
                                subtitle: entries[index].getSubtitle(),
                                leading: entries[index].getIcon(),
                                children: entries[index].createInfo()));
                      },
                    ),
                  ))
                ],
              ),
            );
          } else {
            return const Center(
                child: Text("Unable to connect to the servers."));
          }
        });
  }

  List<List<dynamic>> formatData(List<iMedicalData> list) {
    List<List<dynamic>> retList = [];
    for (iMedicalData temp in list) {
      retList.add([temp.getType(), temp]);
    }
    return retList;
  }

  final Tween<double> turnsTween = Tween<double>(
    begin: 1,
    end: 0,
  );

  List<String> filterNames = [
    "Surgery",
    "Access",
    "Injury",
    "Incident",
    "Drug",
    "Appointment",
    "Allergy"
  ];

  ListView generateFilters() {
    return ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 15),
        itemCount: filterNames.length,
        itemBuilder: ((context, index) {
          return Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.blue, width: 1.0),
                  borderRadius: BorderRadius.circular(5)),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      filterNames[index],
                      style: const TextStyle(color: Colors.blue),
                    ),
                    SizedBox(
                        height: 25,
                        child: Checkbox(
                            value: filters[index],
                            onChanged: (bool? newValue) {
                              setState(() {
                                filters[index] = !filters[index];
                              });
                            }))
                  ]));
        }));
  }
}
