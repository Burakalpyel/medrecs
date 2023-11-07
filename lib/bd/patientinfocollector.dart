import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/patientinfo.dart';

class PatientInfoCollector {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<PatientInfo>? retrieveSocialSec(String documentName) async {
    DocumentSnapshot<Map<String, dynamic>> docSnapshot =
    await _db.collection("SocialSec").doc(documentName).get();
    if (docSnapshot.exists) {
      return PatientInfo.fromDocumentSnapshot(docSnapshot);
    } else {
      throw Exception("Document not found");
    }
  }
}
