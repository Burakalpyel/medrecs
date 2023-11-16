import 'package:flutter/material.dart';
import 'package:medrecs/util/model/patientinfo.dart';
import 'package:medrecs/util/serializables/SETTINGS.dart';
import 'package:medrecs/util/serializables/iMedicalData.dart';
import 'package:medrecs/util/services/patientinfo_service.dart';

class Incident extends iMedicalData {
  @override
  String entryType = "Incident";
  final int userID;
  final List<int> medicalTeamIDs;
  final String incident;
  final String description;
  final String date;
  final String? notes;

  Incident({
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

  @override
  Widget getIcon() {
    return const Icon(
      Icons.gavel_rounded,
      color: Colors.white,
    );
  }

  @override
  Text getSubtitle() {
    return Text(description, style: SETTINGS.SECONDARY_WHITE);
  }

  @override
  Text getSubtitleForDoctor() {
    return const Text(
      "",
      style: SETTINGS.SECONDARY_WHITE,
    );
  }

  @override
  Text getTitle() {
    return Text(
      incident,
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
      title: Text('Medical team: $doctors', style: secondaryWhite),
      contentPadding: tilePadding,
      visualDensity: tileDensity,
    ));
    temp.add(ListTile(
      title: Text('Date of incident: $date', style: secondaryWhite),
      contentPadding: tilePadding,
      visualDensity: tileDensity,
    ));
    if (notes != "") {
      temp.add(ListTile(
        title: Text('Doctor notes: $notes', style: secondaryWhite),
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
    'medicalTeamIDs': medicalTeamIDs,
    'incident': incident,
    'description': description,
    'date': date,
    'notes': notes,
  };

  Future<List<String>> _doctorName() async {
    List<String> doctors = [];
    for (int doctorID in medicalTeamIDs) {
      patientInfoService collector = patientInfoService();
      PatientInfo? user = await collector.retrieveSocialSec(doctorID.toString());
      String fullName = "${user!.name} ${user.surname}";
      doctors.add(fullName);
    }
    return doctors;
  }  
}
