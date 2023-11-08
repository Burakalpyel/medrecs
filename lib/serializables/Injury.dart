import 'package:flutter/material.dart';
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

  @override
  Widget getIcon() {
    return const Icon(Icons.personal_injury);
  }

  @override
  Text getSubtitle() {
    return Text(description);
  }

  @override
  Text getTitle() {
    return Text(injury);
  }

  @override
  List<Widget> createInfo() {
    EdgeInsetsGeometry setting = EdgeInsets.only(left: 0.0, right: 0.0);
    List<Widget> temp = [];
    temp.add(ListTile(
      title: Text('Medical team IDs: $medicalTeamIDs'),
      contentPadding: setting,
    ));
    temp.add(ListTile(
      title: Text('Date of injury: $date'),
      contentPadding: setting,
    ));
    if (notes != null) {
      temp.add(ListTile(
        title: Text('Doctor notes: $notes'),
        contentPadding: setting,
      ));
    }
    return temp;
  }
}
