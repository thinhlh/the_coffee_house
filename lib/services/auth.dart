import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expireDate;
  String _userId;

  bool get isAuth => token != null;

  String get token => (_expireDate != null &&
          _expireDate.isAfter(DateTime.now()) &&
          _token != null)
      ? _token
      : null;

  Future<void> signup(String email, String password) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyBpXGQeF1Hh9itoL5DkVAHX1Xjoq7orPFg';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      print(response.body);
    } catch (error) {}
    notifyListeners();
  }

  Future<void> signin(String email, String password) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyBpXGQeF1Hh9itoL5DkVAHX1Xjoq7orPFg';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      print(response.body);
    } catch (error) {}

    notifyListeners();
  }
}
