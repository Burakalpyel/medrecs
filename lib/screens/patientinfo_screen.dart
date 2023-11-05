import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../bd/userinfocollector.dart';
import '../model/patientinfo.dart';

class PatientInfoScreen extends StatefulWidget {
  const PatientInfoScreen({super.key});

  @override
  State<PatientInfoScreen> createState() => _PatientInfoScreenState();
}

class _PatientInfoScreenState extends State<PatientInfoScreen> {

  PatientInfoCollector collector = PatientInfoCollector();
  Future<PatientInfo>? patientInfo;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
    _initRetrieval();
  }

  Future<void> _initRetrieval() async {
    try {
      PatientInfo? user = await collector.retrieveSocialSec("100200310");
      setState(() {
        patientInfo = Future.value(user);
      });
    } catch (e) {
      // Handle the exception if the document retrieval fails
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("MedRecs"),
      ),
      body: Center(
        child: FutureBuilder<PatientInfo>(
          future: patientInfo,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError || snapshot.data == null) {
              return Text('Error fetching user info');
            } else {
              PatientInfo user = snapshot.data!; // Use null-aware operator here
              return Text('Name: ${user.name}\nSurname: ${user.surname}');
            }
          },
        ),
      ),
    );
  }
}
