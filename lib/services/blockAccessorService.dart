import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:medrecs/serializables/Convertor.dart';
import 'package:medrecs/serializables/iMedicalData.dart';

class blockAccessorService {
  static const String baseURL = "http://10.0.2.2:5000";

  static Future<List<iMedicalData>> getEntries(
      int userID, var queryParameters) async {
    final Dio dio = Dio();
    var response = await dio.get(
      "$baseURL/data/$userID",
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      }),
      data: jsonEncode(queryParameters),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load medical records');
    }
    var responseData = json.decode(response.data) as List;
    List<Map<String, dynamic>>? temp =
        (responseData).map((e) => e as Map<String, dynamic>).toList();
    return temp.map((e) => Convert.convert(e)).toList();
  }

  static dynamic searchFilter(bool surgery, bool userHasAccess, bool injury,
      bool incident, bool drug, bool appointment, bool allergy) {
    return {
      "surgery": surgery,
      "userHasAccess": userHasAccess,
      "injury": injury,
      "incident": incident,
      "drug": drug,
      "appointment": appointment,
      "allergy": allergy
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
