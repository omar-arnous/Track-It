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
}
