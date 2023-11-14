import 'package:flutter/material.dart';
import 'package:medrecs/util/serializables/SETTINGS.dart';
import 'package:medrecs/util/serializables/iMedicalData.dart';

class UserHasAccess extends iMedicalData {
  @override
  String entryType = "UserHasAccess";
  final int userID;
  final int userGrantedAccessID;
  final String date;

  UserHasAccess({
    required this.userID,
    required this.userGrantedAccessID,
    required this.date,
  });

  factory UserHasAccess.fromJson(Map<String, dynamic> json, String type) {
    return UserHasAccess(
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
    return const Icon(
      Icons.folder_shared_rounded,
      color: Colors.white,
    );
  }

  @override
  Text getSubtitle() {
    return Text("$userGrantedAccessID was given access.",
        style: SETTINGS.SECONDARY_WHITE);
  }

  @override
  Text getTitle() {
    return const Text(
      "Access granted",
      style: SETTINGS.TITLE_STYLE,
    );
  }

  @override
  Future<List<ListTile>> createInfo() async {
    EdgeInsetsGeometry tilePadding = SETTINGS.TILE_SIDE_PADDING;
    VisualDensity tileDensity = SETTINGS.TILE_DENSITY;
    return <ListTile>[
      ListTile(
        title:
            Text('Access granted date: $date', style: SETTINGS.SECONDARY_WHITE),
        contentPadding: tilePadding,
        visualDensity: tileDensity,
      ),
    ];
  }

  @override
  String getType() {
    return entryType;
  }

  @override
  Map<String, dynamic> toJson() => {
        'userID': userID,
        'userGrantedAccessID': userGrantedAccessID,
        'date': date,
      };
}
