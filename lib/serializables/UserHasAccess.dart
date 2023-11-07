import 'package:medrecs/serializables/iMedicalData.dart';

class UserHasAccess extends iMedicalData {
  @override
  final String entryType;
  final int userID;
  final int userGrantedAccessID;
  final String date;

  UserHasAccess({
    required this.entryType,
    required this.userID,
    required this.userGrantedAccessID,
    required this.date,
  });

  factory UserHasAccess.fromJson(Map<String, dynamic> json, String type) {
    return UserHasAccess(
      entryType: type,
      userID: json['userID'] as int,
      userGrantedAccessID: json['userGrantedAccessID'] as int,
      date: json['date'] as String,
    );
  }

  @override
  String summarizeData() {
    return "User ID $userID and user granted access ID: $userGrantedAccessID";
  }
}
