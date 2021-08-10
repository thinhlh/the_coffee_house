import 'package:flutter/material.dart';
import 'package:the/tdd/common/domain/entities/custom_user.dart';
import 'package:the/tdd/features/user/domain/usecases/toggle_favorite_product.dart';

class UserProvider with ChangeNotifier {
  ToggleFavoriteProduct _toggleFavoriteProduct;
  UserProvider(this._toggleFavoriteProduct);

  CustomUser _user;

  CustomUser get user => _user;

  set user(CustomUser user) {
    _user = user;
    notifyListeners();
  }

  void update(CustomUser user) {
    _user = user;
    notifyListeners();
  }

  Future<bool> toggleFavoriteProduct(ToggleFavoriteProductParams params) async {
    bool value = true;
    final result = await _toggleFavoriteProduct(params);

    result.fold((failure) => value = false, (right) {
      _user.favoriteProducts = params.productIds;
      notifyListeners();
    });

    return value; // True means update successfully, false means unsuccessfully
  }
}
