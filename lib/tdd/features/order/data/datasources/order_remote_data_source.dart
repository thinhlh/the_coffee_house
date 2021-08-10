import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:the/tdd/core/errors/exceptions.dart';
import 'package:the/tdd/features/order/data/models/cart_item_model.dart';
import 'package:the/tdd/features/order/data/models/order_model.dart';

abstract class OrderRemoteDataSource {
  Future<void> addOrder(OrderModel orderModel);
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> addOrder(OrderModel orderModel) async {
    final ref = _firestore.collection('orders').doc();

    try {
      orderModel.cartItems.forEach((cartItem) async {
        await ref
            .collection('cart')
            .add(cartItem.toMap())
            .timeout(Duration(minutes: 1));
      });

      return ref.set(orderModel.toMap);
    } on TimeoutException {
      throw ConnectionException();
    }
  }
}
