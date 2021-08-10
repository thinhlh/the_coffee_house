import 'package:intl/intl.dart';

class CurrencyHelper {
  static String formatPrice(int value) => NumberFormat.currency(
        locale: 'vi-VN',
        decimalDigits: 0,
      ).format(value);
}
