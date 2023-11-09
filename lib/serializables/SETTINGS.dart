import 'package:flutter/material.dart';

class SETTINGS {
  // ignore: constant_identifier_names
  static const EdgeInsetsGeometry TILE_SIDE_PADDING =
      EdgeInsets.only(left: 15.0, right: 10.0);

  // ignore: constant_identifier_names
  static const TextStyle TITLE_STYLE = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  // ignore: constant_identifier_names
  static const TextStyle SECONDARY_WHITE = TextStyle(
    color: Color.fromARGB(255, 210, 210, 210),
  );

  // ignore: constant_identifier_names
  static const TILE_DENSITY = VisualDensity(horizontal: 0, vertical: -4);

  static const SUBTITLE_REMINDER = TextStyle(fontSize: 16);

  static const TITLE_REMINDER =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
}
