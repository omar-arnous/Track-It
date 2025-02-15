import 'package:flutter/material.dart';

class IconConvertor {
  String iconDataToString(IconData icon) {
    return '${icon.codePoint},${icon.fontFamily}';
  }

  IconData stringToIconData(String iconString) {
    List<String> parts = iconString.split(',');
    return IconData(
      int.parse(parts[0]), // Convert codePoint back to int
      fontFamily: parts[1],
    );
  }
}
