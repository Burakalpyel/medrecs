import 'package:medrecs/util/serializables/iMedicalData.dart';
import 'package:medrecs/util/serializables/iReminderData.dart';

import 'Allergy.dart';
import 'Appointment.dart';
import 'Incident.dart';
import 'UserHasAccess.dart';
import 'Surgery.dart';
import 'Drug.dart';
import 'Injury.dart';

class Convert {
  static iMedicalData convert(Map<String, dynamic> response) {
    return filterWhich(response);
  }

  static iReminderData reminderConvert(Map<String, dynamic> response) {
    Map<String, dynamic> data = response["data"] as Map<String, dynamic>;
    switch (response["type"] as String) {
      case "Appointment":
        return Appointment.fromJson(data, "Appointment");
      default:
        return Drug.fromJson(data, "Drug");
    }
  }

  static iMedicalData filterWhich(Map<String, dynamic> json) {
    Map<String, dynamic> data = json["data"] as Map<String, dynamic>;
    switch (json["type"] as String) {
      case "Surgery":
        return Surgery.fromJson(data, "Surgery");
      case "UserHasAccess":
        return UserHasAccess.fromJson(data, "UserHasAccess");
      case "Incident":
        return Incident.fromJson(data, "Incident");
      case "Allergy":
        return Allergy.fromJson(data, "Allergy");
      case "Appointment":
        return Appointment.fromJson(data, "Appointment");
      case "Drug":
        return Drug.fromJson(data, "Drug");
      default:
        return Injury.fromJson(data, "Injury");
    }
  }
}
