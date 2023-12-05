import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/patientinfo.dart';

// ignore: camel_case_types
class loginService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<PatientInfo>? retrieveSocialSec(String userID) async {
    DocumentSnapshot<Map<String, dynamic>> docSnapshot =
        await _db.collection("SocialSec").doc(userID).get();
    if (docSnapshot.exists) {
      return PatientInfo.fromDocumentSnapshot(docSnapshot);
    } else {
      throw Exception("Document not found");
    }
  }
}
