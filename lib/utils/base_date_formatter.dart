import 'package:intl/intl.dart';

class BaseDateFomatter {
  static String formatDate(DateTime date) =>
      DateFormat('dd-MM-yyyy').format(date);
  static DateTime fromString(String dateString) =>
      DateFormat('dd-MM-yyyy').parse(dateString);
  static String formatDateTime(DateTime dateTime) =>
      DateFormat('EEE, dd MMM yyyy HH:mm:ss').format(dateTime);
}
