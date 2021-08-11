import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:the/providers/cart.dart';

class Order extends Equatable {
  String id;
  String orderAddress;
  String orderMethod;
  DateTime orderTime = DateTime.now();
  int orderValue;
  bool isDelivered = false;
  String promotionId;
  String recipentId;
  String recipientName;
  String recipientPhone;
  Cart cart = Cart();

  Order({
    @required this.id,
    @required this.orderAddress,
    @required this.orderMethod,
    @required this.orderTime,
    @required this.orderValue,
    @required this.isDelivered,
    @required this.recipentId,
    @required this.recipientName,
    @required this.recipientPhone,
    this.cart,
    this.promotionId,
  });

  @override
  List<Object> get props => [id];

  factory Order.fromJson(Map<String, Object> map) {
    return Order(
      id: map['id'],
      orderAddress: map['orderAddress'],
      orderMethod: map['orderMethod'],
      orderTime: (map['orderTime'] as Timestamp).toDate(),
      orderValue: map['orderValue'],
      isDelivered: map['delivered'] ?? false,
      recipentId: map['userId'],
      recipientName: map['recipientName'],
      recipientPhone: map['recipientPhone'],
      promotionId: map['promotionId'],
      // cart: map['cart'],
    );
  }

  String get formattedOrderValue => NumberFormat.currency(
        locale: 'vi-VN',
        decimalDigits: 0,
      ).format(orderValue);

  String get formattedOrderTime =>
      DateFormat('HH:mm dd-MM-yyyy').format(this.orderTime);

  Map<String, Object> toMap() {
    return {
      'orderAddress': this.orderAddress,
      'orderMethod': this.orderMethod,
      'orderTime': DateTime.now(),
      'orderValue': this.orderValue,
      'delivered': this.isDelivered,
      'promotionId': this.promotionId,
      'userId': this.recipentId,
      'recipientName': this.recipientName,
      'recipientPhone': this.recipientPhone,
    };
  }
}
