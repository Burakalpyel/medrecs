import 'package:flutter/material.dart';

abstract class iMedicalData {
  abstract String entryType;

  String summarizeData();
  String getType();
  Text getTitle();
  Text getSubtitle();
  Widget getIcon();
  Future<List<ListTile>> createInfo() async {
    throw UnimplementedError();
  }
  Map<String, dynamic> toJson();
}
