import 'package:flutter/material.dart';
import 'package:medrecs/views/medView/AppointmentFormScreen.dart';
import 'package:medrecs/views/medView/AppointmentsPageScreen.dart';
import 'package:medrecs/views/medView/MedicalRecordAdd.dart';
import 'package:medrecs/util/services/patientinfo_service.dart';
import '../../util/model/patientinfo.dart';

class MedTeamScreen extends StatefulWidget {
  final int userID;
  final PatientInfo userInfo;

  const MedTeamScreen({Key? key, required this.userID, required this.userInfo})
      : super(key: key);

  @override
  _MedTeamScreenState createState() => _MedTeamScreenState();
}

class _MedTeamScreenState extends State<MedTeamScreen> {
  patientInfoService collector = patientInfoService();
  Future<PatientInfo>? patientInfo;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
    _initRetrieval();
  }

  Future<void> _initRetrieval() async {
    if (patientInfo != null) {
      return;
    }

    try {
      PatientInfo? user =
      await collector.retrieveSocialSec(widget.userID.toString());
      setState(() {
        patientInfo = Future.value(user);
      });
    } catch (e) {
      // Handle the exception if the document retrieval fails
      print("E: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the general background color here
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue[600],
              borderRadius: BorderRadius.only(),
            ),
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 40), // Additional space to lower "Welcome" text
                  FutureBuilder<PatientInfo>(
                    future: patientInfo,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(
                          color: Colors.blue[200],
                        );
                      } else if (snapshot.hasError || snapshot.data == null) {
                        return Text(
                          'Error fetching user info',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        );
                      } else {
                        PatientInfo user = snapshot.data!;
                        return Text(
                          "${user.name} ${user.surname}'s Area",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  getPersonalDetails(),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DoctorFormScreen(),
                        ),
                      );
                    },
                    icon: Icon(Icons.receipt_rounded),
                    label: Text(
                      'Add Medical Record',
                      style: TextStyle(fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue[800],
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: EdgeInsets.all(15),
                      fixedSize: Size(
                        MediaQuery.of(context).size.width - 40,
                        60,
                      ),
                    ),
                  ),
                  SizedBox(height: 10), // Add gap between buttons
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AppointmentFormScreen(),
                        ),
                      );
                    },
                    icon: Icon(Icons.calendar_today),
                    label: Text(
                      'Add Appointment',
                      style: TextStyle(fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue[800],
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: EdgeInsets.all(15),
                      fixedSize: Size(
                        MediaQuery.of(context).size.width - 40,
                        60,
                      ),
                    ),
                  ),
                  SizedBox(height: 10), // Add gap between buttons
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AppointmentsPage(userID: widget.userID, userInfo: widget.userInfo),
                        ),
                      );
                    },
                    child: Text(
                      'See Appointments',
                      style: TextStyle(fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue[800],
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: EdgeInsets.all(15),
                      fixedSize: Size(
                        MediaQuery.of(context).size.width - 40,
                        60,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
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

  Expanded getPersonalDetails() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 15, bottom: 20),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            border: Border.all(color: const Color.fromARGB(20, 100, 176, 238)),
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.1),
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
                children: getInfoColumns(),
              ),
              const SizedBox(width: 20), // Add some space between personal details and doctor/hospital details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  // Add doctor/hospital details here
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Column> getInfoColumns() {
    List<String> labels = [
      "  FULL NAME",
      "  BIRTH DATE",
      "  ADDRESS",
      "  PHONE NUMBER",
      "  LOCATION",
      // "  LAST VISITED HOSPITAL",
      // "  LAST VISITED DOCTOR"
    ];
    List<String> details = [
      widget.userInfo.name,
      widget.userInfo.birthday,
      widget.userInfo.address,
      widget.userInfo.phone,
      widget.userInfo.location,
      // widget.userInfo.hospitalName,
      // widget.userInfo.doctorName
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
