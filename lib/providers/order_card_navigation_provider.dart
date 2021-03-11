import 'package:flutter/material.dart';

class OrderCardNavigationProvider with ChangeNotifier {
  bool isDelivery = true;
  OrderCardNavigationProvider({this.isDelivery = true});

  void checkAndUpdateOption(bool delivery) {
    this.isDelivery = delivery;
    notifyListeners();
  }
}
