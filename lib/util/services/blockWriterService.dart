import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:medrecs/util/serializables/Allergy.dart';
import 'package:medrecs/util/serializables/Appointment.dart';
import 'package:medrecs/util/serializables/Drug.dart';
import 'package:medrecs/util/serializables/Incident.dart';
import 'package:medrecs/util/serializables/Injury.dart';
import 'package:medrecs/util/serializables/UserHasAccess.dart';
import 'package:medrecs/util/serializables/iMedicalData.dart';

import '../serializables/Surgery.dart';

class blockWriterService {
  static const String baseURL = "http://10.0.2.2:5000";

  static Future<bool> write(int userID, iMedicalData surgeryData) async {
    final Dio dio = Dio();
    String endpoint = mapDataType(surgeryData);
    try {
      var response = await dio
          .post(
            "$baseURL/data/$endpoint",
            options: Options(headers: {
              HttpHeaders.contentTypeHeader: "application/json",
            }),
            data: jsonEncode(surgeryData.toJson()),
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode != 200) {
        return false;
      }
      return true;
    } on TimeoutException catch (e) {
      return false;
    }
  }

  static String mapDataType(iMedicalData data) {
    switch (data.runtimeType) {
      case Surgery:
        return "surgery";
      case UserHasAccess:
        return "userAccess";
      case Injury:
        return "injury";
      case Incident:
        return "incident";
      case Drug:
        return "drug";
      case Appointment:
        return "appointment";
      case Allergy:
        return "allergy";
      default:
        return "else";
    }
  }
}
