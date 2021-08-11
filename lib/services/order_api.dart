import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the/models/cart_item.dart';
import 'package:the/models/order.dart';
import 'package:the/providers/cart.dart';

class OrderAPI {
  FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addOrder(Order order) async {
    final ref = _db.collection('orders').doc();
    order.cart.cartItems.forEach((element) async {
      await ref.collection('cart').add(element.toMap());
    });
    return ref.set(order.toMap());
  }

  Future<Order> fetchOrder(String orderId) {
    DocumentReference docRef = _db.collection('orders').doc(orderId);
    return docRef.get().then((document) {
      Map<String, Object> json = document.data();
      json['id'] = document.id;
      return Order.fromJson(json);
    }).then((order) => docRef
            .collection('cart')
            .get()
            .then((cartItemsQuerySnapshot) => cartItemsQuerySnapshot.docs
                .map((cartItemDocument) =>
                    CartItem.fromMap(cartItemDocument.data()))
                .toList())
            .then((cartItems) {
          Cart cart = Cart();
          cartItems.forEach((cartItem) => cart.addCartItem(cartItem));
          order.cart = cart;
          return order;
        }));
  }

  Future<Order> fetchCartItemToOrder(Order currentOrder) async {
    return _db
        .collection('orders')
        .doc(currentOrder.id)
        .collection('cart')
        .get()
        .then((cartItemsQuerySnapshot) => cartItemsQuerySnapshot.docs
            .map(
              (cartItemDocument) => CartItem.fromMap(cartItemDocument.data()),
            )
            .toList())
        .then((cartItems) {
      Cart cart = Cart();
      cartItems.forEach((cartItem) => cart.addCartItem(cartItem));
      currentOrder.cart = cart;
      return currentOrder;
    });
  }

  Stream<Order> getStreamOrder(String orderId) =>
      _db.collection('orders').doc(orderId).snapshots().map((documentSnapshot) {
        Map<String, Object> json = documentSnapshot.data();
        json['id'] = documentSnapshot.id;
        return Order.fromJson(json);
      });
}
