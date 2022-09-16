import 'package:flutter/material.dart';
import 'package:the/models/order.dart';
import 'package:the/services/admin_orders_api.dart';

class AdminOrders with ChangeNotifier {
  List<Order> _orders = [];

  AdminOrders.initialize();

  List<Order> get orders => [..._orders];

  AdminOrders.fromList(this._orders) {
    notifyListeners();
  }

  Order getOrderById(String id) {
    return _orders.firstWhere((element) => element.id == id,
        orElse: () => null);
  }

  List<Order> get deliveredOrders {
    return [..._orders].where((orders) => orders.isDelivered).toList();
  }

  List<Order> get notDeliveredOrders {
    return [..._orders].where((orders) => !orders.isDelivered).toList();
  }

  Future<void> delivery({
    String orderId,
    String recipentId,
    int expectedPoint,
  }) {
    return AdminOrdersAPI().delivery(
      orderId: orderId,
      recipientId: recipentId,
      expectedPoint: expectedPoint,
    );
  }
}
