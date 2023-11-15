import 'package:flutter/material.dart';
import 'package:medrecs/util/model/patientinfo.dart';
import 'package:medrecs/util/serializables/SETTINGS.dart';
import 'package:medrecs/util/serializables/iReminderData.dart';
import 'package:medrecs/util/services/patientinfo_service.dart';

class Appointment extends iReminderData {
  @override
  String entryType = "Appointment";
  final int userID;
  final int doctorID;
  final int medicalCenter;
  final String reason;
  final String date;
  final String time;

  Appointment({
    required this.userID,
    required this.doctorID,
    required this.medicalCenter,
    required this.reason,
    required this.date,
    required this.time,
  });

  factory Appointment.fromJson(Map<String, dynamic> json, String type) {
    return Appointment(
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
  Text getSubtitleForDoctor() {
    return Text(
      "Patient ID: $doctorID",
      style: SETTINGS.SUBTITLE_REMINDER,
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
  Future<List<ListTile>> createInfo() async {
    List<ListTile> temp = [];
    EdgeInsetsGeometry tilePadding = SETTINGS.TILE_SIDE_PADDING;
    VisualDensity tileDensity = SETTINGS.TILE_DENSITY;
    TextStyle secondaryWhite = SETTINGS.SECONDARY_WHITE;

    String doctorName = await _doctorName();

    temp.add(ListTile(
      title: Text('Doctor: $doctorName', style: secondaryWhite),
      contentPadding: tilePadding,
      visualDensity: tileDensity,
    ));
    temp.add(ListTile(
      title: Text('Medical Center\'s ID: $medicalCenter', style: secondaryWhite),
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

  @override
  Map<String, dynamic> toJson() => {
    'userID': userID,
    'doctorID': doctorID,
    'medicalCenter': medicalCenter,
    'date': date,
    'reason': reason,
    'time': time,
  };

  Future<String> _doctorName() async {
    patientInfoService collector = patientInfoService();
    PatientInfo? user = await collector.retrieveSocialSec(doctorID.toString());
    String fullName = "${user!.name} ${user.surname}";
    return fullName;
  }  
}
