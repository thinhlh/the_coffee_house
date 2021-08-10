import 'package:flutter/foundation.dart';
import 'package:the/tdd/features/order/domain/entities/cart_item.dart';

class CartItemModel extends CartItem {
  CartItemModel({
    @required String productId,
    @required int quantity,
    @required String title,
    @required String note,
    unitPrice,
  }) : super(
          productId: productId,
          quantity: quantity,
          title: title,
          note: note,
          unitPrice: unitPrice,
        );

  Map<String, dynamic> toMap() {
    return {
      'productId': this.productId,
      'note': this.note,
      'quantity': this.quantity,
      'itemPrice': this.unitPrice,
    };
  }

  CartItemModel.fromMap(Map<String, dynamic> map) {
    this.productId = map['productId'];
    this.unitPrice = map['itemPrice'];
    this.note = map['note'];
    this.quantity = map['quantity'];
  }
}

extension Mapping on CartItem {
  Map<String, dynamic> toMap() => {
        'productId': this.productId,
        'note': this.note,
        'quantity': this.quantity,
        'itemPrice': this.unitPrice,
      };
}
