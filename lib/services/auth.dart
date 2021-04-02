import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:the_coffee_house/models/custom_user.dart';

import 'package:the_coffee_house/models/http_exception.dart';
import 'package:the_coffee_house/services/fire_store.dart';
import 'package:the_coffee_house/services/firestore_user.dart';

class Auth extends FireStoreApi {
  FirebaseAuth _auth = FirebaseAuth.instance;

  bool get isAuth => _auth.currentUser != null;

  Stream<User> get user => _auth.authStateChanges();

  Future<void> signin(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
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

  Future<void> signOut() async {
    try {
      await _auth.signOut();
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

  Future<void> signup(CustomUser user, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: password,
      );
      user.uid = userCredential.user.uid;
      await FireStoreUser().addUser(user);
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
