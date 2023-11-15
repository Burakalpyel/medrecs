import 'package:flutter/material.dart';

abstract class iMedicalData {
  abstract String entryType;

  String summarizeData();
  String getType();
  Text getTitle();
  Text getSubtitle();
  Text getSubtitleForDoctor();
  Widget getIcon();
  List<ListTile> createInfo();
  Map<String, dynamic> toJson();
}
