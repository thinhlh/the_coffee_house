import 'package:flutter/cupertino.dart';
import 'package:the_coffee_house/models/user.dart';
import 'package:the_coffee_house/services/fire_store.dart';

class UserProvider with ChangeNotifier {
  User user;

  void toggleFavoriteStatus(String productId) {
    user.favoriteProducts[productId] = !user.favoriteProducts[productId];

    notifyListeners();
  }
}
