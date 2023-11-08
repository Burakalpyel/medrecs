import 'package:flutter/material.dart';

abstract class iMedicalData {
  abstract final String entryType;

  String summarizeData();
  Text getTitle();
  Text getSubtitle();
  Widget getIcon();
  List<Widget> createInfo();
}
