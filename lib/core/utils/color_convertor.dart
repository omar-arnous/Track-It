import 'package:flutter/material.dart';

class ColorConvertor {
  String colorToHexString(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
  }

  Color hexStringToColor(String hexColor) {
    return Color(int.parse(hexColor.replaceFirst('#', ''), radix: 16));
  }
}
