import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_coffee_house/models/custom_user.dart';

import 'package:the_coffee_house/models/http_exception.dart';
import 'package:the_coffee_house/services/fire_store.dart';
import 'package:the_coffee_house/services/firestore_user.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String _token;

  bool get isAuth => user != null && token != null;

  User get user => _auth.currentUser;

  String get token => _token;

  Future<void> signin(String email, String password) async {
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

  Future<void> signup(CustomUser user, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: password,
      );
      user.uid = userCredential.user.uid;
      _token = await this.user.getIdToken();
      await FireStoreUser().addUser(user);
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
