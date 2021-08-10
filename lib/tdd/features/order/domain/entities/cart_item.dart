import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class CartItem extends Equatable {
  String productId;
  String title;
  int unitPrice;
  int quantity;
  String note;

  CartItem({
    @required this.productId,
    @required this.title,
    @required this.unitPrice,
    @required this.quantity,
    this.note,
  });

  int get cartItemValue => quantity * unitPrice;

  @override
  List<Object> get props => [productId, quantity];
}
