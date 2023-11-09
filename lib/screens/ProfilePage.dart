import 'package:flutter/material.dart';

import '../bd/patientinfocollector.dart';
import '../model/patientinfo.dart';

class ProfilePage extends StatefulWidget {

  final String userID;
  const ProfilePage({Key? key, required this.userID}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

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
      PatientInfo? user = await collector.retrieveSocialSec(widget.userID);
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
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      //   title: const Text("MedRecs"),
      // ),
      body: Center(
        child: FutureBuilder<PatientInfo>(
          future: patientInfo,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError || snapshot.data == null) {
              return const Text('Error fetching user info');
            } else {
              PatientInfo user = snapshot.data!; // Use null-aware operator here
              return Text('Name: ${user.name}\n' +
                'Surname: ${user.surname}\n' +
                'Birthday: ${user.birthday}\n' +
                'Address: ${user.address}\n' +
                'Location: ${user.location}\n' +
                'Phone: ${user.phone}'
                );
            }
          },
        ),
      ),
    );
  }
}
