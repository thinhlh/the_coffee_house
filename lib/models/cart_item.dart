import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class CartItem extends Equatable {
  String productId;
  String title;
  int unitPrice;
  String note;
  int quantity;

  CartItem({
    @required this.productId,
    @required this.unitPrice,
    @required this.note,
    @required this.quantity,
    this.title,
  });

  Map<String, Object> toMap() {
    return {
      'productId': productId,
      'note': note,
      'quantity': quantity,
      'itemPrice': unitPrice,
    };
  }

  CartItem.fromMap(Map<String, Object> map) {
    this.productId = map['productId'];
    this.unitPrice = map['itemPrice'];
    this.note = map['note'];
    this.quantity = map['quantity'];
  }

  int get price => quantity * unitPrice;

  String get formmatedPrice => NumberFormat.currency(
        locale: 'vi-VN',
        decimalDigits: 0,
      ).format(price);

  @override
  List<Object> get props => [
        this.productId,
        this.note,
      ];

  @override
  String toString() {
    return productId;
  }
}
