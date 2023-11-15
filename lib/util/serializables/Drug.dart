import 'package:flutter/material.dart';
import 'package:medrecs/util/serializables/SETTINGS.dart';
import 'package:medrecs/util/serializables/iReminderData.dart';

class Drug extends iReminderData {
  @override
  String entryType = "Drug";
  final int userID;
  final int doctorID;
  final String drug;
  final String startDate;
  final String endDate;
  final String reason;
  final String? notes;

  Drug({
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

  @override
  Widget getIcon() {
    return const Icon(
      Icons.medication_liquid,
      color: Colors.white,
    );
  }

  @override
  Text getSubtitle() {
    return Text("$startDate - $endDate", style: SETTINGS.SECONDARY_WHITE);
  }

  @override
  Text getSubtitleForDoctor() {
    return Text(
      "",
      style: SETTINGS.SECONDARY_WHITE,
    );
  }

  @override
  Text getTitle() {
    return Text(
      "$drug preescription",
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
      title: Text('Doctor\'s ID: $doctorID', style: secondaryWhite),
      contentPadding: tilePadding,
      visualDensity: tileDensity,
    ));
    temp.add(ListTile(
      title: Text('Reason: $reason', style: secondaryWhite),
      contentPadding: tilePadding,
      visualDensity: tileDensity,
    ));
    if (notes != "") {
      temp.add(ListTile(
        title: Text('Preescription notes: $notes', style: secondaryWhite),
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
  Widget getReminderIcon() {
    return const Icon(Icons.medication_liquid);
  }

  @override
  Text getReminderSubtitle() {
    return Text("$startDate - $endDate", style: SETTINGS.SUBTITLE_REMINDER);
  }

  @override
  Text getReminderTitle() {
    return Text(
      "$drug preescription",
      style: SETTINGS.TITLE_REMINDER,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'userID': userID,
        'doctorID': doctorID,
        'drug': drug,
        'startDate': startDate,
        'endDate': endDate,
        'reason': reason,
        'notes': notes,
      };
}
