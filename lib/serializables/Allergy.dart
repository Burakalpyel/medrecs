import 'package:flutter/material.dart';
import 'package:medrecs/serializables/iMedicalData.dart';

class Allergy extends iMedicalData {
  @override
  final String entryType;
  final int userID;
  final String allergy;
  final String dateOfDiscovery;
  final String treatment;
  final String? notes;

  Allergy({
    required this.entryType,
    required this.userID,
    required this.allergy,
    required this.dateOfDiscovery,
    required this.treatment,
    required this.notes,
  });

  factory Allergy.fromJson(Map<String, dynamic> json, String type) {
    return Allergy(
      entryType: type,
      userID: json['userID'] as int,
      allergy: json['allergy'] as String,
      dateOfDiscovery: json['dateOfDiscovery'] as String,
      treatment: json['treatment'] as String,
      notes: json['notes'] as String,
    );
  }

  @override
  String summarizeData() {
    return "User ID $userID and allergy name: $allergy";
  }

  @override
  Widget getIcon() {
    return Icon(Icons.do_not_touch_rounded);
  }

  @override
  Text getSubtitle() {
    return Text("Allergic reaction discovered on ${dateOfDiscovery}");
  }

  @override
  Text getTitle() {
    return Text("${allergy} allergy");
  }

  @override
  List<Widget> createInfo() {
    EdgeInsetsGeometry setting = EdgeInsets.only(left: 0.0, right: 0.0);
    List<Widget> temp = [];
    temp.add(ListTile(
      title: Text('Specified treatment: $treatment'),
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
