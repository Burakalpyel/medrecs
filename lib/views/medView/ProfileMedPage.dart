import 'package:flutter/material.dart';
import 'package:medrecs/util/model/patientinfo.dart';
import 'package:medrecs/util/services/patientinfo_service.dart';
import 'package:nfc_manager/nfc_manager.dart';

class ProfileMedPage extends StatefulWidget {
  final int userID;
  final PatientInfo userInfo;

  const ProfileMedPage({Key? key, required this.userID, required this.userInfo})
      : super(key: key);

  @override
  State<ProfileMedPage> createState() => _ProfileMedPageState();
}

class _ProfileMedPageState extends State<ProfileMedPage> {
  patientInfoService collector = patientInfoService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[800],
      body: SafeArea(
        child: Column(
          children: [
            getHeader(),
            const SizedBox(
              height: 10,
            ),
            getButtomsAndTitle(),
          ],
        ),
      ),
    );
  }

  Padding getHeader() {
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
                  [widget.userInfo.name, "'s Personal Area"].join(),
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

  Expanded getButtomsAndTitle() {
    return Expanded(
        child: Container(
      padding: const EdgeInsets.all(25),
      color: Colors.grey[100],
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: produceButtoms(),
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
          getPersonalDetails(),
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

  List<Column> produceButtoms() {
    List<Column> list = [];
    List<String> names = ["EDIT", "RECEIVE", "SETTINGS"];
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
                if (names[i] == "RECEIVE") {
                  print(names[i]);
                  try {
                    bool isAvailable = await NfcManager.instance.isAvailable();

                    if (isAvailable) {
                      NfcManager.instance.startSession(
                        onDiscovered: (NfcTag tag) async {
                          debugPrint('NFC Tag Detected: ${tag.data}');
                          print("Successful reading data via NFC: ${tag.data}");
                        },
                      );
                    } else {
                      debugPrint('NFC not available.');
                    }
                  } catch (e) {
                    debugPrint('Error reading NFC: $e');
                  }
                }
                else print("IMPLEMENT");
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

  Expanded getPersonalDetails() {
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
                children: getInfoColumns(),
              )
            ],
          )),
    ));
  }

  List<Column> getInfoColumns() {
    List<String> labels = [
      "  FULL NAME",
      "  BIRTH DATE",
      "  ADDRESS",
      "  PHONE NUMBER",
      "  LOCATION"
    ];
    List<String> details = [
      "${widget.userInfo.name} ${widget.userInfo.surname}",
      widget.userInfo.birthday,
      widget.userInfo.address,
      widget.userInfo.phone,
      widget.userInfo.location
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
