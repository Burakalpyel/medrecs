import 'package:medrecs/serializables/iMedicalData.dart';

class Injury extends iMedicalData {
  @override
  final String entryType;
  final int userID;
  final List<int> medicalTeamIDs;
  final String injury;
  final String description;
  final String date;
  final String? notes;

  Injury({
    required this.entryType,
    required this.userID,
    required this.medicalTeamIDs,
    required this.injury,
    required this.description,
    required this.date,
    required this.notes,
  });

  factory Injury.fromJson(Map<String, dynamic> json, String type) {
    var tempList = json['medicalTeamIDs'] as List<dynamic>;
    List<int> real = tempList.cast<int>();
    return Injury(
      entryType: type,
      userID: json['userID'] as int,
      medicalTeamIDs: real,
      injury: json['injury'] as String,
      description: json['description'] as String,
      date: json['date'] as String,
      notes: json['notes'] as String,
    );
  }

  @override
  String summarizeData() {
    return "User ID $userID has the injury: $injury";
  }
}
