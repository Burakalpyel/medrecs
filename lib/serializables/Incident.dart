import 'package:medrecs/serializables/iMedicalData.dart';

class Incident extends iMedicalData {
  @override
  final String entryType;
  final int userID;
  final List<int> medicalTeamIDs;
  final String incident;
  final String description;
  final String date;
  final String? notes;

  Incident({
    required this.entryType,
    required this.userID,
    required this.medicalTeamIDs,
    required this.incident,
    required this.description,
    required this.date,
    required this.notes,
  });

  factory Incident.fromJson(Map<String, dynamic> json, String type) {
    var tempList = json['medicalTeamIDs'] as List<dynamic>;
    List<int> real = tempList.cast<int>();
    return Incident(
      entryType: type,
      userID: json['userID'] as int,
      medicalTeamIDs: real,
      incident: json['incident'] as String,
      description: json['description'] as String,
      date: json['date'] as String,
      notes: json['notes'] as String,
    );
  }

  @override
  String summarizeData() {
    return "User ID $userID and the incident name: $incident";
  }
}
