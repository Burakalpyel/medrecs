import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:medrecs/serializables/iMedicalData.dart';

class Drug extends iMedicalData {
  @override
  final String entryType;
  final int userID;
  final int doctorID;
  final String drug;
  final String startDate;
  final String endDate;
  final String reason;
  final String? notes;

  Drug({
    required this.entryType,
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
      entryType: type,
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
    return const Icon(Icons.medication_liquid);
  }

  @override
  Text getSubtitle() {
    return Text("$startDate - $endDate");
  }

  @override
  Text getTitle() {
    return Text("$drug preescription");
  }

  @override
  List<Widget> createInfo() {
    EdgeInsetsGeometry setting = EdgeInsets.only(left: 0.0, right: 0.0);
    List<Widget> temp = [];
    temp.add(ListTile(
      title: Text('Doctor\'s ID: $doctorID'),
      contentPadding: setting,
    ));
    temp.add(ListTile(
      title: Text('Drug\'s preescription reason: $reason'),
      contentPadding: setting,
    ));
    if (notes != null) {
      temp.add(ListTile(
        title: Text('Preescription notes: $notes'),
        contentPadding: setting,
      ));
    }
    return temp;
  }
}
