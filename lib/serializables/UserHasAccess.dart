import 'package:flutter/material.dart';
import 'package:medrecs/serializables/iMedicalData.dart';

class UserHasAccess extends iMedicalData {
  @override
  final String entryType;
  final int userID;
  final int userGrantedAccessID;
  final String date;

  UserHasAccess({
    required this.entryType,
    required this.userID,
    required this.userGrantedAccessID,
    required this.date,
  });

  factory UserHasAccess.fromJson(Map<String, dynamic> json, String type) {
    return UserHasAccess(
      entryType: type,
      userID: json['userID'] as int,
      userGrantedAccessID: json['userGrantedAccessID'] as int,
      date: json['date'] as String,
    );
  }

  @override
  String summarizeData() {
    return "User ID $userID and user granted access ID: $userGrantedAccessID";
  }

  @override
  Widget getIcon() {
    return const Icon(Icons.folder_shared_rounded);
  }

  @override
  Text getSubtitle() {
    return Text("$userGrantedAccessID was given access.");
  }

  @override
  Text getTitle() {
    return const Text("Access granted");
  }

  @override
  List<Widget> createInfo() {
    EdgeInsetsGeometry setting = EdgeInsets.only(left: 0.0, right: 0.0);
    return <Widget>[
      ListTile(
        title: Text('Access granted date: $date'),
        contentPadding: setting,
      ),
    ];
  }
}
