import 'package:flutter/material.dart';
import 'package:medrecs/serializables/SETTINGS.dart';
import 'package:medrecs/serializables/iReminderData.dart';

class Appointment extends iReminderData {
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

  @override
  Widget getIcon() {
    return const Icon(
      Icons.calendar_month,
      color: Colors.white,
    );
  }

  @override
  Text getSubtitle() {
    return Text(
      "$date @ $time",
      style: SETTINGS.SECONDARY_WHITE,
    );
  }

  @override
  Text getTitle() {
    return Text(
      reason,
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
      title:
          Text('Medical Center\'s ID: $medicalCenter', style: secondaryWhite),
      contentPadding: tilePadding,
      visualDensity: tileDensity,
    ));
    return temp;
  }

  @override
  String getType() {
    return entryType;
  }

  @override
  Widget getReminderIcon() {
    return const Icon(Icons.calendar_month);
  }

  @override
  Text getReminderSubtitle() {
    return Text(
      "$date @ $time",
      style: SETTINGS.SUBTITLE_REMINDER,
    );
  }

  @override
  Text getReminderTitle() {
    return Text(
      reason,
      style: SETTINGS.TITLE_REMINDER,
    );
  }
}
