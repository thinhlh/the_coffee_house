import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:the_coffee_house/models/http_exception.dart';

import '../models/http_exception.dart';
import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;

  String _token;
  String _userId;

  bool get isAuth => token != null;

  String get userId => _userId;

  String get token => _token != null ? _token : null;

  Future<void> _authenticate(
      String email, String password, String segment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$segment?key=AIzaSyBpXGQeF1Hh9itoL5DkVAHX1Xjoq7orPFg';
    try {
      final response = await http.post(
        Uri.parse(url),
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
      //_expireDate=DateTime.now().add(responseData[])
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signin(String email, String password) async {
    //return await _authenticate(email, password, 'signInWithPassword');
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      _userId = userCredential.user.uid;
      _token = userCredential.credential.token.toString();
      print(_userId);
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw HttpException(e.code);
      } else if (e.code == 'wrong-password') {
        throw HttpException(e.code);
      }
    }
  }

  Future<void> signup(String email, String password) async {
    return await _authenticate(email, password, 'signUp');
  }
}
