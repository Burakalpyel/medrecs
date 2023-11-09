import 'package:cloud_firestore/cloud_firestore.dart';

class PatientInfo {
  final String name;
  final String surname;
  final String birthday;
  final String address;
  final String location;
  final String phone;

  PatientInfo({required this.name, required this.surname, required this.birthday, required this.address, required this.location, required this.phone});

  Map<String, dynamic> toMap() {
    return {'Name': name, 'Surname': surname, 'Birthday': birthday, 'Address': address, 'Location': location, 'Phone': phone};
  }

  PatientInfo.fromMap(Map<String, dynamic> userInfoMap)
      : name = userInfoMap["Name"],
        surname = userInfoMap["Surname"], 
        birthday = userInfoMap["Birthday"],
        address = userInfoMap["Address"],
        location = userInfoMap["Location"],
        phone = userInfoMap["Phone"];

  PatientInfo.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : name = doc.data()!["Name"],
        surname = doc.data()!["Surname"],
        birthday = doc.data()!["Birthday"],
        address = doc.data()!["Address"],
        location = doc.data()!["Location"],
        phone = doc.data()!["Phone"];
}
