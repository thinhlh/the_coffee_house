import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:the_coffee_house/models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expireDate;
  String _userId;

  bool get isAuth => token != null;

  String get userId => _userId;

  String get token => (_expireDate != null &&
          _expireDate.isAfter(DateTime.now()) &&
          _token != null)
      ? _token
      : null;

  Future<void> _authenticate(
      String email, String password, String segment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$segment?key=AIzaSyBpXGQeF1Hh9itoL5DkVAHX1Xjoq7orPFg';
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
      final responseData = json.decode(response.body);
      if (responseData['error'] != null)
        throw (HttpException(responseData['error']['message']));

      _userId = responseData['localId'];
      _token = responseData['idToken'];
      print(isAuth);
      _expireDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      //_expireDate=DateTime.now().add(responseData[])
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signin(String email, String password) async {
    return await _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> signup(String email, String password) async {
    return await _authenticate(email, password, 'signUp');
  }
}
