import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:the_coffee_house/models/cart_item.dart';

class Cart with ChangeNotifier {
  /// String is the id of product in the cart;
  List<CartItem> _cartItems = [];

  double get totalPrice => _cartItems.fold(
        0,
        (previousValue, cartItem) =>
            previousValue + cartItem.quantity * cartItem.unitPrice,
      );

  String get formattedTotalPrice => NumberFormat.currency(
        locale: 'vi-VN',
        decimalDigits: 0,
      ).format(totalPrice);

  List<CartItem> get cart => [..._cartItems];

  int get numberOfItems => _cartItems.fold(
      0, (previousValue, element) => previousValue += element.quantity);

  bool get isEmpty => _cartItems.isEmpty;

  void addCartItem(String productId, CartItem cartItem) {
    // If _cartItems contains product Id => increase quantity by 1, else add to the cart

    if (_cartItems.isEmpty)
      _cartItems.add(cartItem);
    else {
      final index =
          _cartItems.indexWhere((item) => item.productId == productId);
      if (index <= -1)
        _cartItems.add(cartItem);
      else
        _cartItems[index].quantity += cartItem.quantity;
    }
    notifyListeners();
  }

  void deleteCardItem(CartItem cartItem) {}

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
