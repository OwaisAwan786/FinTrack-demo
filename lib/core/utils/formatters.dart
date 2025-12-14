import 'package:intl/intl.dart';

class Formatters {
  static String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(symbol: 'PKR ', decimalDigits: 0);
    return formatter.format(amount);
  }
}
