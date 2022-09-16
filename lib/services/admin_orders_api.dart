import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:the/models/order.dart';
import 'package:the/providers/admin_orders.dart';

import '../models/product.dart';
import 'fire_store.dart';

class AdminOrdersAPI {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<AdminOrders> get stream => firestore
      .collection('orders')
      .orderBy('orderTime', descending: true)
      .snapshots()
      .map(
        (querySnapshot) => AdminOrders.fromList(
          querySnapshot.docs.map(
            (queryDocumentSnapshot) {
              Map<String, dynamic> json = queryDocumentSnapshot.data();
              json['id'] = queryDocumentSnapshot.id;
              return Order.fromJson(json);
            },
          ).toList(),
        ),
      );

  Future<void> delete(String orderId) async {
    return firestore.collection('orders').doc(orderId).delete();
  }

  Future<void> delivery({
    String orderId,
    String recipientId,
    int expectedPoint,
  }) async {
    return firestore
        .collection('orders')
        .doc(orderId)
        .update({'delivered': true}).then((value) => firestore
            .collection('users')
            .doc(recipientId)
            .update({'point': expectedPoint}));
  }
}
