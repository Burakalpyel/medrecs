import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:medrecs/util/serializables/Convertor.dart';
import 'package:medrecs/util/serializables/iMedicalData.dart';
import 'package:medrecs/util/serializables/iReminderData.dart';

class blockAccessorService {
  static const String baseURL = "http://10.0.2.2:5000";

  static Future<List<iMedicalData>> getEntries(
      int userID, var queryParameters) async {
    final Dio dio = Dio();
    try {
      var response = await dio
          .get(
            "$baseURL/data/$userID",
            options: Options(headers: {
              HttpHeaders.contentTypeHeader: "application/json",
            }),
            data: jsonEncode(queryParameters),
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode != 200) {
        throw Exception('Failed to load medical records');
      }
      var responseData = json.decode(response.data) as List;
      List<Map<String, dynamic>>? temp =
          (responseData).map((e) => e as Map<String, dynamic>).toList();
      return temp.map((e) => Convert.convert(e)).toList();
    } on TimeoutException catch (e) {
      throw Exception(e);
    }
  }

  static Future<List<iReminderData>> getReminderEntries(int userID) async {
    List<bool> onlyReminders = [false, false, false, false, true, true, false];
    final Dio dio = Dio();
    try {
      var response = await dio
          .get(
            "$baseURL/data/$userID",
            options: Options(headers: {
              HttpHeaders.contentTypeHeader: "application/json",
            }),
            data: jsonEncode(searchFilter(onlyReminders)),
          )
          .timeout(const Duration(seconds: 5));
      if (response.statusCode != 200) {
        throw Exception('Failed to load medical records');
      }
      var responseData = json.decode(response.data) as List;
      List<Map<String, dynamic>>? temp =
          (responseData).map((e) => e as Map<String, dynamic>).toList();
      return temp.map((e) => Convert.reminderConvert(e)).toList();
    } on TimeoutException catch (e) {
      throw Exception(e);
    }
  }

  static dynamic searchFilter(List<bool> filters) {
    return {
      "surgery": filters[0],
      "userHasAccess": filters[1],
      "injury": filters[2],
      "incident": filters[3],
      "drug": filters[4],
      "appointment": filters[5],
      "allergy": filters[6]
    };
  }

  static dynamic searchFilterAllTrue() {
    return {
      "surgery": true,
      "userHasAccess": true,
      "injury": true,
      "incident": true,
      "drug": true,
      "appointment": true,
      "allergy": true
    };
  }
}
