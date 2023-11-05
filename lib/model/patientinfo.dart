import 'package:cloud_firestore/cloud_firestore.dart';

class PatientInfo {
  final String name;
  final String surname;

  PatientInfo({required this.name, required this.surname});

  Map<String, dynamic> toMap() {
    return {'Name': name, 'Surname': surname};
  }

  PatientInfo.fromMap(Map<String, dynamic> userInfoMap)
      : name = userInfoMap["Name"],
        surname = userInfoMap["Surname"];

  PatientInfo.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : name = doc.data()!["Name"],
        surname = doc.data()!["Surname"];
}
