import 'package:medrecs/serializables/iMedicalData.dart';

class Appointment extends iMedicalData {
  @override
  final String entryType;
  final int userID;
  final int doctorID;
  final int medicalCenter;
  final String reason;
  final String date;
  final String time;

  Appointment({
    required this.entryType,
    required this.userID,
    required this.doctorID,
    required this.medicalCenter,
    required this.reason,
    required this.date,
    required this.time,
  });

  factory Appointment.fromJson(Map<String, dynamic> json, String type) {
    return Appointment(
      entryType: type,
      userID: json['userID'] as int,
      doctorID: json['doctorID'] as int,
      medicalCenter: json['medicalCenter'] as int,
      reason: json['reason'] as String,
      date: json['date'] as String,
      time: json['time'] as String,
    );
  }

  @override
  String summarizeData() {
    return "User ID $userID has an appointment on the $date, @ $time";
  }
}
