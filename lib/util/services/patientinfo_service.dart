import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/patientinfo.dart';

// ignore: camel_case_types
class patientInfoService {
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

  Future<void> updateSocialSec(String userId, PatientInfo updatedUserInfo) async {
    try {
      await _db.collection("SocialSec").doc(userId).update(updatedUserInfo.toMap());
    } catch (e) {
      print("Error updating user information: $e");
      throw Exception("Error updating user information");
    }
  }
}
