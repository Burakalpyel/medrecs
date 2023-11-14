import 'package:flutter/material.dart';
import 'package:medrecs/views/medView/AppointmentFormScreen.dart';
import 'package:medrecs/views/medView/MedicalRecordAdd.dart';
import 'package:medrecs/util/services/patientinfo_service.dart';
import '../../util/model/patientinfo.dart';

class MedTeamScreen extends StatefulWidget {
  final int userID;

  const MedTeamScreen({Key? key, required this.userID}) : super(key: key);

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
                          'Welcome, ${user.name} ${user.surname}',
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
