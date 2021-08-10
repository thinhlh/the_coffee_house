import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:the/tdd/features/order/domain/entities/cart_item.dart';
import 'package:the/tdd/features/order/domain/entities/order_method.dart';

class Order extends Equatable {
  final String id;

  /// This can either store id or recipent indicated address
  final String orderAddress;
  final OrderMethod orderMethod;
  final DateTime orderTime;
  final int orderValue;
  final bool isDelivered;
  final String promotionId;
  final String recipientId;
  final String recipientName;
  final String recipientPhone;
  final List<CartItem> cartItems;

  Order({
    @required this.id,
    @required this.orderAddress,
    @required this.orderMethod,
    @required this.orderValue,
    @required this.isDelivered,
    @required this.recipientName,
    @required this.cartItems,
    this.recipientId,
    this.orderTime,
    this.promotionId,
    this.recipientPhone,
  });

  @override
  List<Object> get props => [this.id];
}
