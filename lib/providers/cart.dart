import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:the/models/promotion.dart';

import '../models/cart_item.dart';

class Cart with ChangeNotifier {
  /// String is the id of product in the cart;
  List<CartItem> _cartItems = [];
  Promotion _promotion;

  //Total cart item value, no promotion
  int get totalCartItemsValue => _cartItems.fold(
        0,
        (previousValue, cartItem) =>
            previousValue + cartItem.quantity * cartItem.unitPrice,
      );

  //After choosing promotion
  int get totalOrderValue {
    if (_promotion == null) {
      return totalCartItemsValue;
    } else {
      if (_promotionValue <= 100) {
        return (totalCartItemsValue * (1 - _promotionValue / 100)).toInt();
      } else
        return totalCartItemsValue - _promotionValue;
    }
  }

  int get _promotionValue {
    String promotionValue = _promotion.value;
    if (promotionValue.contains('%')) {
      return int.parse(promotionValue.substring(0, promotionValue.length - 1));
    } else {
      return int.parse(promotionValue);
    }
  }

  String get formattedTotalCartItem => NumberFormat.currency(
        locale: 'vi-VN',
        decimalDigits: 0,
      ).format(totalCartItemsValue);

  String get formattedTotalOrderValue => NumberFormat.currency(
        locale: 'vi-VN',
        decimalDigits: 0,
      ).format(totalOrderValue);

  List<CartItem> get cartItems => [..._cartItems];

  int get numberOfItems => _cartItems.fold(
        0,
        (previousValue, element) => previousValue += element.quantity,
      );

  bool get isEmpty => _cartItems.isEmpty;

  void addCartItem(CartItem cartItem) {
    // If _cartItems contains product Id => increase quantity by 1, else add to the cart

    if (_cartItems.isEmpty)
      _cartItems.add(cartItem);
    else {
      final index = _cartItems.indexWhere((item) => item == cartItem);
      if (index <= -1)
        _cartItems.add(cartItem);
      else
        _cartItems[index].quantity += cartItem.quantity;
    }
    notifyListeners();
  }

  void deleteCartItem(CartItem cartItem) {
    _cartItems.remove(cartItem);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    _promotion = null;
    notifyListeners();
  }

  set promotion(Promotion promotion) {
    _promotion = promotion;
    notifyListeners();
  }

  Promotion get promotion => _promotion;
}
