import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_coffee_house/models/user.dart' as custom_user;

import 'package:the_coffee_house/models/http_exception.dart';
import 'package:the_coffee_house/services/fire_store.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String _token;

  bool get isAuth => user != null && token != null;

  User get user => _auth.currentUser;

  String get token => _token;

  Future<void> signin(String email, String password) async {
    //return await _authenticate(email, password, 'signInWithPassword');
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _token = await user.getIdToken();

      notifyListeners();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw HttpException(e.code);
      } else if (e.code == 'wrong-password') {
        throw HttpException(e.code);
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(custom_user.User user, String password) async {
    try {
      String uid;
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: password,
      );
      uid = userCredential.user.uid;
      _token = await this.user.getIdToken();
      await FireStoreApi().addUser(
        custom_user.User(
          uid: uid,
          email: user.email,
          name: user.name,
          birthday: user.birthday,
        ),
      );
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw HttpException(e.code);
      } else if (e.code == 'email-already-in-use') {
        throw HttpException(e.code);
      }
    } catch (error) {
      throw error;
    }
  }
}
