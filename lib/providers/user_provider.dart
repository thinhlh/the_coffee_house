import 'package:flutter/material.dart';
import 'package:the_coffee_house/models/custom_user.dart';
import 'package:the_coffee_house/services/firestore_user.dart';

class UserProvider with ChangeNotifier {
  CustomUser _user;

  CustomUser get user => _user;

  UserProvider(this._user);

  UserProvider update(String uid) {
    FireStoreUser().firestore.collection('users').doc(uid).get().then((value) {
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
    );
  }

  UserProvider.fromJson(Map<String, dynamic> json) {
    _user = CustomUser.fromJson(json);
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
      await FireStoreUser().toggleFavoriteProduct(
        user.uid,
        user.favoriteProducts,
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
