import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:the/utils/const.dart';

class AdminDashboardService {
  Future<Map> fetchProfit(DateTime fromDate, DateTime toDate) async {
    final response = await http.get(
        Uri.parse(SERVER_ENDPOINT +
            '/profit/?fromDate=' +
            DateFormat('yyyy-MM-dd').format(fromDate) +
            '&toDate=' +
            DateFormat('yyyy-MM-dd').format(toDate)),
        headers: {
          'Authorization': 'the-coffee-house',
          'Content-Type': 'application/json',
        });
    return json.decode(response.body);
  }
}
