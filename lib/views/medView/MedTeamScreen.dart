import 'package:flutter/material.dart';
import 'package:medrecs/util/model/patientinfo.dart';
import 'package:medrecs/util/model/user_data.dart';
import 'package:medrecs/views/medView/AppointmentFormScreen.dart';
import 'package:medrecs/views/medView/AppointmentsPageScreen.dart';
import 'package:medrecs/views/medView/MedicalRecordAdd.dart';
import 'package:medrecs/views/medView/nfc_screen.dart';
import 'package:medrecs/views/userView/settings_screen.dart';
import 'package:provider/provider.dart';

class MedTeamScreen extends StatefulWidget {
  final int userID;
  final PatientInfo userInfo;

  const MedTeamScreen({Key? key, required this.userID, required this.userInfo})
      : super(key: key);

  @override
  _MedTeamScreenState createState() => _MedTeamScreenState();
}

class _MedTeamScreenState extends State<MedTeamScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    var userData = Provider.of<UserData>(context);

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: theme.colorScheme.background,
        body: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.primaryColor,
                borderRadius: const BorderRadius.only(),
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    FutureBuilder<PatientInfo>(
                      future: Future.value(userData.userInfo),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator(
                            color: theme.colorScheme.onPrimary,
                          );
                        } else if (snapshot.hasError || snapshot.data == null) {
                          return const Text(
                            'Error fetching user info',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          );
                        } else {
                          PatientInfo user = snapshot.data!;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "${user.name} ${user.surname}'s Area",
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Personal Details",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: theme.colorScheme.onPrimary,
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        produceButton("RECEIVE", Icons.share, theme),
                        produceButton("SETTINGS", Icons.settings, theme),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 14),
                        decoration: BoxDecoration(
                        color: theme.cardColor,
                        border: Border.all(color: theme.primaryColor.withOpacity(0.2)),
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: theme.primaryColor.withOpacity(0.1),
                            spreadRadius: 15,
                            blurRadius: 10,
                            offset: const Offset(0, 20),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: getInfoColumns(userData.userInfo),
                          ),
                          const SizedBox(width: 20),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              // Add doctor/hospital details here
                            ),
                          ),
                        ],
                      ),
                    ),
                    BottomNavigationBar(
                      currentIndex: _selectedIndex,
                      onTap: _onItemTapped,
                      items: const [
                        BottomNavigationBarItem(
                          icon: Icon(Icons.receipt_rounded),
                          label: 'Add Record',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.calendar_today),
                          label: 'Add Appointment',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.event),
                          label: 'Appointments',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget produceButton(String name, IconData icon, ThemeData theme) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            // Handle button tap
            if (name == "RECEIVE") {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MedNFCScreen(userID: widget.userID)
              ));
            } else if (name == "SETTINGS") {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SettingsScreen(userID: widget.userID)
              ));
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: theme.primaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(12),
            child: Icon(
              icon,
              color: theme.colorScheme.onPrimary,
              size: 20,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (_selectedIndex) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DoctorFormScreen(userID: widget.userID),
          ),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AppointmentFormScreen(userID: widget.userID),
          ),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AppointmentsPage(
                userID: widget.userID),
          ),
        );
        break;
    }
  }

  String formatString(String name) {
    int countNewLines = 0;
    if (name.length < 23) {
      return name;
    }
    for (int i = 1; i < name.length / 23; i++) {
      name =
      "${name.substring(0, i * 23 + i - 1)}\n${name.substring(i * 23 + i - 1)}";
      countNewLines++;
    }
    var chars = name.split('');
    if (countNewLines != 0) {
      for (int space = chars.length - 1; space > -1; space--) {
        if (chars[space] == ' ') {
          int indexnl = -1;
          for (int newLine = space; newLine < chars.length; newLine++) {
            if (chars[newLine] == '\n') {
              indexnl = newLine;
            }
          }
          if (indexnl != -1) {
            chars[space] = '\n';
            for (int l = indexnl; l < chars.length - 1; l++) {
              chars[l] = chars[l + 1];
            }
            chars[chars.length - 1] = '';
            String newName = "";
            for (String a in chars) {
              newName = newName + a;
            }
            return newName;
          }
        }
      }
    }
    return name;
  }

  List<Column> getInfoColumns(PatientInfo userInfo) {
    List<String> labels = [
      "  FULL NAME",
      "  BIRTH DATE",
      "  ADDRESS",
      "  PHONE NUMBER",
      "  LOCATION"
    ];
    List<String> details = [
      "${userInfo.name} ${userInfo.surname}",
      userInfo.birthday,
      userInfo.address,
      userInfo.phone,
      userInfo.location,
    ];
    TextStyle styleInfo = const TextStyle(
        fontWeight: FontWeight.bold,
        letterSpacing: 3,
        wordSpacing: 6,
        fontSize: 18);
    TextStyle styleLabels = TextStyle(
        color: Colors.grey[500],
        letterSpacing: 2,
        wordSpacing: 4,
        fontSize: 14);
    List<Column> list = [];
    for (int i = 0; i < labels.length; i++) {
      list.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(labels[i], style: styleLabels),
          Text(formatString(details[i]), style: styleInfo)
        ],
      ));
    }
    return list;
  }
}
