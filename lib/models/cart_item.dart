import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class CartItem {
  final String productId;
  final String title;
  final double unitPrice;
  int quantity;

  CartItem({
    @required this.productId,
    @required this.title,
    @required this.unitPrice,
    @required this.quantity,
  });

  double get price => quantity * unitPrice;

  String get formmatedPrice => NumberFormat.currency(
        locale: 'vi-VN',
        decimalDigits: 0,
      ).format(price);
}
