// ignore: file_names
import 'package:flutter/material.dart';
import 'package:medrecs/util/serializables/iMedicalData.dart';

// ignore: camel_case_types
abstract class iReminderData extends iMedicalData {
  Text getReminderTitle();
  Text getReminderSubtitle();
  Widget getReminderIcon();
}
