import 'package:flutter/material.dart';
import 'package:medrecs/util/model/patientinfo.dart';
import 'package:medrecs/util/services/patientinfo_service.dart';

class ProfilePage extends StatefulWidget {
  final int userID;
  const ProfilePage({Key? key, required this.userID}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
          await collector.retrieveSocialSec(widget.userID as String);
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
              return Text(
                  'Name: ${user.name}\nSurname: ${user.surname}\nBirthday: ${user.birthday}\nAddress: ${user.address}\nLocation: ${user.location}\nPhone: ${user.phone}');
            }
          },
        ),
      ),
    );
  }
}
