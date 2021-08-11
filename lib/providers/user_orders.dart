import 'package:flutter/material.dart';
import 'package:the/models/order.dart';
import 'package:the/models/product.dart';
import 'package:the/services/order_api.dart';

class UserOrders with ChangeNotifier {
  List<Order> _orders = [];

  UserOrders.initialize();

  List<Order> get orders => [..._orders];

  UserOrders.fromList(this._orders) {
    notifyListeners();
  }

  List<Order> get deliveredOrders {
    return [..._orders].where((orders) => orders.isDelivered).toList();
  }

  List<Order> get notDeliveredOrders {
    return [..._orders].where((orders) => !orders.isDelivered).toList();
  }

  Future<List<String>> get recentlyOrderedProducts async {
    List<String> recentlyOrderedProductsList = [];
    final lastOrder = await OrderAPI().fetchOrder(_orders.first.id);
    lastOrder.cart.cartItems.forEach((cartItem) {
      if (!recentlyOrderedProductsList.contains(cartItem.productId))
        recentlyOrderedProductsList.add(cartItem.productId);
    });
    return recentlyOrderedProductsList;
  }
}
