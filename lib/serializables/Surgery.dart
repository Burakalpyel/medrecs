import 'package:flutter/material.dart';
import 'package:medrecs/serializables/SETTINGS.dart';
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
    return const Icon(
      Icons.local_hospital,
      color: Colors.white,
    );
  }

  @override
  Text getSubtitle() {
    return Text(date, style: SETTINGS.SECONDARY_WHITE);
  }

  @override
  Text getTitle() {
    return Text(
      surgeryName,
      style: SETTINGS.TITLE_STYLE,
    );
  }

  @override
  List<ListTile> createInfo() {
    List<ListTile> temp = [];
    EdgeInsetsGeometry tilePadding = SETTINGS.TILE_SIDE_PADDING;
    VisualDensity tileDensity = SETTINGS.TILE_DENSITY;
    TextStyle secondaryWhite = SETTINGS.SECONDARY_WHITE;
    temp.add(ListTile(
      title: Text('Hospital ID\'s: $hospitalID', style: secondaryWhite),
      contentPadding: tilePadding,
      visualDensity: tileDensity,
    ));
    temp.add(ListTile(
      title: Text('Surgeon team IDs: $surgeonTeamIDs', style: secondaryWhite),
      contentPadding: tilePadding,
      visualDensity: tileDensity,
    ));
    temp.add(ListTile(
      title: Text('Description: $description', style: secondaryWhite),
      contentPadding: tilePadding,
      visualDensity: tileDensity,
    ));
    if (notes != "") {
      temp.add(ListTile(
        title: Text('Surgeon\'s notes: $notes', style: secondaryWhite),
        contentPadding: tilePadding,
        visualDensity: tileDensity,
      ));
    }
    return temp;
  }

  @override
  String getType() {
    return entryType;
  }
}
