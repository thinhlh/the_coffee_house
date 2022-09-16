import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:the/models/cart_item.dart';
import 'package:the/models/order.dart';
import 'package:the/providers/user_orders.dart';
import 'package:the/services/fire_store.dart';

class UserOrdersAPI implements BaseAPI {
  @override
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<void> add(object) {
    // TODO: implement add
  }

  @override
  Future<void> delete(String id) {
    // TODO: implement delete
  }

  @override
  Stream<UserOrders> get stream => firestore
      .collection('orders')
      .orderBy('orderTime', descending: true)
      .where('userId', isEqualTo: FirebaseAuth.instance.currentUser.uid)
      .snapshots()
      .map(
        (ordersQuerySnapshot) => UserOrders.fromList(
          ordersQuerySnapshot.docs.map((orderDocument) {
            Map<String, Object> json = orderDocument.data();
            json['id'] = orderDocument.id;
            return Order.fromJson(json);
          }).toList(),
        ),
      );

  Stream<List<CartItem>> getCartItemStream(String orderId) {
    return firestore
        .collection('orders')
        .doc(orderId)
        .collection('cart')
        .snapshots()
        .map(
          (cartItemsSnapshot) => cartItemsSnapshot.docs
              .map((cartItemDocument) =>
                  CartItem.fromMap(cartItemDocument.data()))
              .toList(),
        );
  }

  Future<List<Order>> getOrdersFuture() {
    return firestore
        .collection('orders')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .get()
        .then(
          (ordersSnapshot) => ordersSnapshot.docs.map((orderDocument) {
            Map<String, Object> json = orderDocument.data();
            json['id'] = orderDocument.id;
            return Order.fromJson(json);
          }).toList(),
        );
  }

  @override
  Future<void> update(newObject) {
    // TODO: implement update
  }
}
