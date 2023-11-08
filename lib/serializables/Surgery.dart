import 'package:flutter/material.dart';
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

  @override
  Widget getIcon() {
    return const Icon(Icons.local_hospital);
  }

  @override
  Text getSubtitle() {
    return Text(date);
  }

  @override
  Text getTitle() {
    return Text(surgeryName);
  }

  @override
  List<Widget> createInfo() {
    EdgeInsetsGeometry setting = EdgeInsets.only(left: 0.0, right: 0.0);
    List<Widget> temp = [];
    temp.add(ListTile(
      title: Text('Hospital ID\'s: $hospitalID'),
      contentPadding: setting,
    ));
    temp.add(ListTile(
      title: Text('Surgeon team IDs: $surgeonTeamIDs'),
      contentPadding: setting,
    ));
    temp.add(ListTile(
      title: Text('Description: $description'),
      contentPadding: setting,
    ));
    if (notes != null) {
      temp.add(ListTile(
        title: Text('Surgeon\'s notes: $notes'),
        contentPadding: setting,
      ));
    }
    return temp;
  }
}
