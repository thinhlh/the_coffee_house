import 'package:flutter/material.dart';

class ProductInfoProvider with ChangeNotifier {
  int _quantity = 1;

  int get quantity => _quantity;

  set quantity(int quantity) {
    _quantity = quantity;
    notifyListeners();
  }
}
