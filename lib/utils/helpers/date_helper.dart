import 'package:intl/intl.dart';

class DateHelper {
  static String ddMMyy(DateTime dateTime) {
    return DateFormat('dd-MM-yy').format(dateTime);
  }

  static DateTime parsedMMyy(String value) {
    return DateFormat('dd-MM-yy').parse(value);
  }
}
