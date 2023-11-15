import 'package:flutter/material.dart';
import 'SETTINGS.dart';
import 'iMedicalData.dart';

class Allergy extends iMedicalData {
  @override
  String entryType = "Allergy";
  final int userID;
  final String allergy;
  final String dateOfDiscovery;
  final String treatment;
  final String? notes;

  Allergy({
    required this.userID,
    required this.allergy,
    required this.dateOfDiscovery,
    required this.treatment,
    required this.notes,
  });

  factory Allergy.fromJson(Map<String, dynamic> json, String type) {
    return Allergy(
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
    return const Icon(
      Icons.do_not_touch_rounded,
      color: Colors.white,
    );
  }

  @override
  Text getSubtitle() {
    return Text(
      "Allergic reaction on $dateOfDiscovery",
      style: SETTINGS.SECONDARY_WHITE,
    );
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
      allergy,
      style: SETTINGS.TITLE_STYLE,
    );
  }

  @override
  Future<List<ListTile>> createInfo() async {
    List<ListTile> temp = [];
    EdgeInsetsGeometry tilePadding = SETTINGS.TILE_SIDE_PADDING;
    VisualDensity tileDensity = SETTINGS.TILE_DENSITY;
    TextStyle secondaryWhite = SETTINGS.SECONDARY_WHITE;
    temp.add(ListTile(
      title: Text('Specified treatment: $treatment', style: secondaryWhite),
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
        'allergy': allergy,
        'dateOfDiscovery': dateOfDiscovery,
        'treatment': treatment,
        'notes': notes,
      };
}
