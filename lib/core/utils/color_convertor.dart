import 'package:flutter/material.dart';

class ColorConvertor {
  static String colorToHexString(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
  }

  static Color hexStringToColor(String hexColor) {
    return Color(int.parse(hexColor.replaceFirst('#', ''), radix: 16));
  }
}
