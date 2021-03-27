import 'package:flutter/material.dart';
import 'package:the_coffee_house/models/custom_user.dart';
import 'package:the_coffee_house/services/firestore_user.dart';

class UserProvider with ChangeNotifier {
  CustomUser _user;

  CustomUser get user => _user;

  final String _userUid;

  UserProvider(this._userUid);

  List<String> get favoriteProducts => [..._user.favoriteProducts];

  Future<CustomUser> fetchUser() async {
    if (_user != null) return user;
    _user = await FireStoreUser().getUser(_userUid);
    return _user;
  }

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
