import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Formatter {
  static String formatCurrency(String currency) {
    switch (currency) {
      case 'usd':
        return '\$';
      case 'syp':
        return 'SYP';
      default:
        return '';
    }
  }

  static String formatBalance(double balance) {
    return NumberFormat('#,##0.00').format(balance);
  }

  static String formatDate(DateTime date, {String format = 'dd-MM-yyyy'}) {
    return DateFormat(format).format(date);
  }

  static String formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
