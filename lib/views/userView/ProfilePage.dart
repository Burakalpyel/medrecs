import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:medrecs/util/model/patientinfo.dart';
import 'package:medrecs/util/model/user_data.dart';
import 'package:medrecs/views/userView/edit_profile.dart';
import 'package:medrecs/views/userView/settings_screen.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  final int userID;

  ProfilePage({Key? key, required this.userID})
      : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // patientInfoService collector = patientInfoService();

  @override
  Widget build(BuildContext context) {
    var userData = Provider.of<UserData>(context);
    return Scaffold(
      backgroundColor: Colors.blue[800],
      body: SafeArea(
        child: Column(
          children: [
            getHeader(userData.userInfo),
            const SizedBox(
              height: 10,
            ),
            getButtomsAndTitle(userData.userInfo),
          ],
        ),
      ),
    );
  }

  Padding getHeader(PatientInfo userInfo) {
    List<String> months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    DateTime now = DateTime.now();
    String date = "${now.day} ${months[now.month - 1]}, ${now.year}";
    return Padding(
      padding: const EdgeInsets.only(top: 25.0, left: 25.0, right: 25.0),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  [userInfo.name, "'s Personal Area"].join(),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(date,
                    style: TextStyle(
                      color: Colors.blue[200],
                    ))
              ],
            ),
          ],
        ),
      ]),
    );
  }

  Expanded getButtomsAndTitle(PatientInfo userInfo) {
    return Expanded(
        child: Container(
      padding: const EdgeInsets.all(25),
      color: Colors.grey[100],
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: produceButtoms(userInfo),
          ),
          const Divider(height: 25),
          const Text(
            "PERSONAL DETAILS",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Divider(
            height: 12,
            color: Colors.blue[200],
            indent: 80,
            endIndent: 80,
          ),
          const SizedBox(
            height: 8,
          ),
          getPersonalDetails(userInfo),
        ],
      ),
    ));
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

  List<Column> produceButtoms(PatientInfo userInfo) {
    List<Column> list = [];
    List<String> names = ["EDIT", "SHARE", "SETTINGS"];
    List<Icon> icons = [
      const Icon(
        Icons.edit,
        color: Colors.white,
      ),
      const Icon(
        Icons.medical_information,
        color: Colors.white,
      ),
      const Icon(
        Icons.settings,
        color: Colors.white,
      ),
    ];
    for (int i in [0, 1, 2]) {
      list.add(Column(
        children: [
          InkWell(
              onTap: () async {
                if (names[i] == "EDIT") {
                  navigateToEditProfile();
                }
                else if (names[i] == "SHARE") {
                  try {
                    bool isAvailable = await NfcManager.instance.isAvailable();

                    if (isAvailable) {
                      NfcManager.instance.startSession(
                        onDiscovered: (NfcTag tag) async {
                          print(names[i]);
                          try {
                            NdefMessage message = NdefMessage([NdefRecord.createText(widget.userID.toString())]);
                            await Ndef.from(tag)?.write(message);

                            print("Successful sharing data via NFC: ${message}");
                            debugPrint('Data emitted successfully');
                            Uint8List payload = message.records.first.payload;
                            String text = String.fromCharCodes(payload);
                            debugPrint("Written data: $text");
                            print("Second check: ${text}");

                            NfcManager.instance.stopSession();
                          } catch (e) {
                            debugPrint('Error emitting NFC data: $e');
                          }
                        }
                      );
                    } else {
                      debugPrint('NFC not available.');
                    }
                  } catch (e) {
                    debugPrint('Error writing to NFC: $e');
                  }
                }
                else if (names[i] == "SETTINGS") {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SettingsScreen(userID: widget.userID)
                  ));
                }
              },
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.blue[600],
                      borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.all(12),
                  child: SizedBox(width: 40, height: 40, child: icons[i]))),
          const SizedBox(height: 5),
          Text(
            names[i],
            style: const TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ));
    }
    return list;
  }

  Expanded getPersonalDetails(PatientInfo userInfo) {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 20),
      child: Container(
          padding:
              const EdgeInsets.only(top: 8, bottom: 8, right: 14, left: 14),
          decoration: BoxDecoration(
              color: Colors.grey[100],
              border:
                  Border.all(color: const Color.fromARGB(20, 100, 176, 238)),
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.1),
                  spreadRadius: 15,
                  blurRadius: 10,
                  offset: const Offset(0, 20),
                ),
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: getInfoColumns(userInfo),
              )
            ],
          )),
    ));
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
      userInfo.location
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
  void navigateToEditProfile() async {
    // Navigate to the second page and await the result
    PatientInfo? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfile(
          userID: widget.userID,
        ),
      ),
    );

    if (result != null) {
      // Update the user information in the UserData provider
      Provider.of<UserData>(context, listen: false).updateUserInfo(result);

      // Update the local userInfo in the ProfilePage
      // setState(() {
      //   widget.userInfo = result;
      // });
    }
  }
}
