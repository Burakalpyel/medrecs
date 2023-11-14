import 'package:flutter/material.dart';
import 'package:medrecs/util/model/patientinfo.dart';
import 'package:medrecs/util/serializables/SETTINGS.dart';
import 'package:medrecs/util/serializables/iMedicalData.dart';
import 'package:medrecs/util/services/patientinfo_service.dart';

class Surgery extends iMedicalData {
  @override
  String entryType = "Surgery";
  final int userID;
  final String surgeryName;
  final int hospitalID;
  final List<int> surgeonTeamIDs;
  final String description;
  final String date;
  final String? notes;

  Surgery({
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
  Future<List<ListTile>> createInfo() async {
    List<ListTile> temp = [];
    EdgeInsetsGeometry tilePadding = SETTINGS.TILE_SIDE_PADDING;
    VisualDensity tileDensity = SETTINGS.TILE_DENSITY;
    TextStyle secondaryWhite = SETTINGS.SECONDARY_WHITE;

    List<String> doctors = await _doctorName();

    temp.add(ListTile(
      title: Text('Hospital ID\'s: $hospitalID', style: secondaryWhite),
      contentPadding: tilePadding,
      visualDensity: tileDensity,
    ));
    temp.add(ListTile(
      title: Text('Surgeon team: $doctors', style: secondaryWhite),
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

  @override
  Map<String, dynamic> toJson() => {
    'userID': userID,
    'surgeryName': surgeryName,
    'hospitalID': hospitalID,
    'surgeonTeamIDs': surgeonTeamIDs,
    'description': description,
    'date': date,
    'notes': notes,
  };

  Future<List<String>> _doctorName() async {
    List<String> doctors = [];
    for (int doctorID in surgeonTeamIDs) {
      patientInfoService collector = patientInfoService();
      PatientInfo? user = await collector.retrieveSocialSec(doctorID.toString());
      String fullName = "${user!.name} ${user.surname}";
      doctors.add(fullName);
    }
    return doctors;
  }  
}
