import 'package:flutter/material.dart';
import '../bd/patientinfocollector.dart';
import '../model/patientinfo.dart';

class MedTeamScreen extends StatefulWidget {
  final int userID;

  const MedTeamScreen({Key? key, required this.userID}) : super(key: key);

  @override
  _MedTeamScreenState createState() => _MedTeamScreenState();
}

class _MedTeamScreenState extends State<MedTeamScreen> {
  PatientInfoCollector collector = PatientInfoCollector();
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
      PatientInfo? user = await collector.retrieveSocialSec(widget.userID.toString());
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
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: FutureBuilder<PatientInfo>(
                future: patientInfo,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError || snapshot.data == null) {
                    return Text('Error fetching user info');
                  } else {
                    PatientInfo user = snapshot.data!;
                    return Text(
                      'Welcome, ${user.name} ${user.surname}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                // Add Medical Records Button
                ElevatedButton.icon(
                  onPressed: () {
                    // Implement logic to add medical records
                  },
                  icon: Icon(Icons.receipt_rounded),
                  label: Text(
                    'Add Medical Record',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                // Add Appointments Button
                ElevatedButton.icon(
                  onPressed: () {
                    // Implement logic to add appointments
                  },
                  icon: Icon(Icons.calendar_today),
                  label: Text(
                    'Add Appointment',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                // Add Reminders Button
                ElevatedButton.icon(
                  onPressed: () {
                    // Implement logic to add reminders
                  },
                  icon: Icon(Icons.notifications),
                  label: Text(
                    'Add Reminder',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
