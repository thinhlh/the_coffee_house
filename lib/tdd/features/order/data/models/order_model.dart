import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:the/tdd/features/order/domain/entities/cart_item.dart';
import 'package:the/tdd/features/order/domain/entities/order.dart';
import 'package:the/tdd/features/order/domain/entities/order_method.dart';

class OrderModel extends Order {
  OrderModel({
    @required String orderAddress,
    @required OrderMethod orderMethod,
    @required int orderValue,
    @required String recipientName,
    @required String promotionId,
    @required String recipientPhone,
    String id,
    bool isDelivered,
    String recipientId,
    List<CartItem> cartItems,
    DateTime orderTime,
  }) : super(
          id: id,
          orderAddress: orderAddress,
          orderMethod: orderMethod,
          orderValue: orderValue,
          isDelivered: isDelivered,
          recipientName: recipientName,
          recipientPhone: recipientPhone,
          orderTime: orderTime,
          promotionId: promotionId,
          cartItems: cartItems,
        );

  Map<String, Object> get toMap => {
        'orderAddress': this.orderAddress,
        'orderMethod': this.orderMethod.valueString,
        'orderTime': this.orderTime ?? DateTime.now(),
        'orderValue': this.orderValue,
        'delivered': this.isDelivered,
        'promotionId': this.promotionId,
        'userId': FirebaseAuth.instance.currentUser.uid,
        'recipientName': this.recipientName,
        'recipientPhone': this.recipientPhone,
      };

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'],
      orderAddress: map['orderAddress'],
      orderMethod: map['orderMethod'] == 'Delivery'
          ? OrderMethod.Delivery
          : OrderMethod.TakeAway,
      orderTime: map['orderTime'] is Timestamp
          ? (map['orderTime'] as Timestamp).toDate()
          : DateTime.now(),
      orderValue: map['orderValue'],
      isDelivered: map['delivered'] ?? false,
      recipientId: map['userId'],
      recipientName: map['recipientName'],
      recipientPhone: map['recipientPhone'],
      promotionId: map['promotionId'],
      // cart: map['cart'],
    );
  }
}
