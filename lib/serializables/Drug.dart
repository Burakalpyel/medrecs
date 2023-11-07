import 'package:medrecs/serializables/iMedicalData.dart';

class Drug extends iMedicalData {
  @override
  final String entryType;
  final int userID;
  final int doctorID;
  final String drug;
  final String startDate;
  final String endDate;
  final String reason;
  final String? notes;

  Drug({
    required this.entryType,
    required this.userID,
    required this.doctorID,
    required this.drug,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.notes,
  });

  factory Drug.fromJson(Map<String, dynamic> json, String type) {
    return Drug(
      entryType: type,
      userID: json['userID'] as int,
      doctorID: json['doctorID'] as int,
      drug: json['drug'] as String,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      reason: json['reason'] as String,
      notes: json['notes'] as String,
    );
  }

  @override
  String summarizeData() {
    return "User ID $userID has been given the drug $drug until: $endDate";
  }
}
