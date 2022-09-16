import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:the/utils/const.dart';
import 'package:the/utils/exceptions/authenticate_exception.dart';

import '../models/custom_user.dart';
import '../providers/user_provider.dart';
import 'package:http/http.dart' as http;

class UserAPI {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<UserProvider> get user => firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .snapshots()
          .map((documentSnapshot) {
        Map<String, dynamic> json = documentSnapshot.data();
        json['uid'] = documentSnapshot.id;
        return UserProvider.fromJson(json);
      });

  Future<void> addUser(CustomUser user) async {
    CollectionReference users = firestore.collection('users');

    //Create a document with id received from auth
    try {
      final isExists = await users.doc(user.uid).get();

      if (!isExists.exists) {
        await users.doc(user.uid).set(user.toJson());
      }
    } catch (error) {
      //TODO handling error
      throw error;
    }
  }

  Future<void> toggleFavoriteProduct(
      String userUid, List<String> favoriteProducts) async {
    try {
      await firestore
          .collection('users')
          .doc(userUid)
          .update({'favoriteProducts': favoriteProducts});
    } catch (error) {
      //TODO handling error
    }
  }

  Future<void> toggleReceiveNotification(
    bool isExpectedToReceiveNotification,
  ) {
    return firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .update({'subscribeToNotifications': isExpectedToReceiveNotification});
  }

  Future<void> editUser(Map<String, dynamic> newData) async {
    try {
      await firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .update(newData);
    } catch (error) {
      //TODO handling error
      throw error;
    }
  }

  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    User user = FirebaseAuth.instance.currentUser;

    AuthCredential authCredential = EmailAuthProvider.credential(
      email: user.email,
      password: currentPassword,
    );

    try {
      await FirebaseAuth.instance.currentUser
          .reauthenticateWithCredential(authCredential);
    } on FirebaseAuthException catch (e) {
      throw AuthenticateException();
    }
    return user.updatePassword(newPassword).then(
          (value) => print('Change password completed'),
          onError: (error) => print(error),
        );
  }

  Future<Map<String, Object>> fetchUserInDepthInfo(String uid) {
    return http.get(
      Uri.parse(SERVER_ENDPOINT + '/user-info/$uid'),
      headers: {'Authorization': 'the-coffee-house'},
    ).then((value) => json.decode(value.body));
  }
}
