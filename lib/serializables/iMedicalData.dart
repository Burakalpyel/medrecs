import 'package:flutter/material.dart';

abstract class iMedicalData {
  abstract final String entryType;

  String summarizeData();
  String getType();
  Text getTitle();
  Text getSubtitle();
  Widget getIcon();
  List<ListTile> createInfo();
}
