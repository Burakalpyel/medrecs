import 'package:flutter/material.dart';
import 'package:medrecs/serializables/iMedicalData.dart';

abstract class iReminderData extends iMedicalData {
  Text getReminderTitle();
  Text getReminderSubtitle();
  Widget getReminderIcon();
}
