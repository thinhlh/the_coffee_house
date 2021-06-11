import 'package:flutter/material.dart';

class OrderCardNavigationProvider with ChangeNotifier {
  bool isDelivery = true;

  /// If [isDelivery]=true => location is address of customer
  /// Else location is the id of store
  String _location;
  OrderCardNavigationProvider({this.isDelivery = true});

  void checkAndUpdateOption(bool delivery) {
    this.isDelivery = delivery;
    notifyListeners();
  }

  set location(String location) {
    this._location = location;
    notifyListeners();
  }

  get location => this._location;
}
