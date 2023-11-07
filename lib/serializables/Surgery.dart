import 'package:medrecs/serializables/iMedicalData.dart';

class Surgery extends iMedicalData {
  @override
  final String entryType;
  final int userID;
  final String surgeryName;
  final int hospitalID;
  final List<int> surgeonTeamIDs;
  final String description;
  final String date;
  final String? notes;

  Surgery({
    required this.entryType,
    required this.userID,
    required this.surgeryName,
    required this.hospitalID,
    required this.surgeonTeamIDs,
    required this.description,
    required this.date,
    required this.notes,
  });

  factory Surgery.fromJson(Map<String, dynamic> json, String type) {
    var tempList = json['surgeonTeamIDs'] as List<dynamic>;
    List<int> real = tempList.cast<int>();
    return Surgery(
      entryType: type,
      userID: json['userID'] as int,
      surgeryName: json['surgeryName'] as String,
      hospitalID: json['hospitalID'] as int,
      surgeonTeamIDs: real,
      description: json['description'] as String,
      date: json['date'] as String,
      notes: json['notes'] as String,
    );
  }

  @override
  String summarizeData() {
    return "User ID $userID and surgery name: $surgeryName";
  }
}
