import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/custom_user.dart';
import '../services/user_api.dart';

class UserProvider with ChangeNotifier {
  CustomUser _user;

  CustomUser get user => _user;

  UserProvider(this._user);

  UserProvider update(String uid) {
    UserAPI().firestore.collection('users').doc(uid).get().then((value) {
      final json = value.data();
      json['uid'] = value.id;
      _user = CustomUser.fromJson(json);
    });

    return this;
  }

  UserProvider.initialize() {
    this._user = CustomUser(
      uid: '',
      name: '',
      email: '',
      birthday: DateTime.now(),
      favoriteProducts: [],
      isAdmin: false,
    );
  }

  UserProvider.fromJson(Map<String, dynamic> json) {
    this._user = CustomUser.fromJson(json);
    notifyListeners();
  }

  List<String> get favoriteProducts => [..._user.favoriteProducts];

  bool isFavorite(String productId) {
    return user.favoriteProducts.contains(productId);
  }

  void toggleFavoriteStatus(String productId) async {
    try {
      if (user.favoriteProducts.contains(productId))
        user.favoriteProducts.remove(productId);
      else
        user.favoriteProducts.add(productId);
      await UserAPI().toggleFavoriteProduct(
        user.uid,
        user.favoriteProducts,
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> changePassword(String currentPassword, String newPassword) {
    return UserAPI().changePassword(currentPassword, newPassword);
  }

  Future<void> fetchUser() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((value) {
      Map<String, dynamic> json = value.data();
      json['uid'] = value.id;
      return UserProvider.fromJson(json);
    });
  }

  Future<void> toggleReceiveNotification(bool isExpectedToReceiveNotification) {
    return UserAPI().toggleReceiveNotification(isExpectedToReceiveNotification);
  }
}
