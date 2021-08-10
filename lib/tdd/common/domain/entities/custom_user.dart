import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import 'membership.dart';

// ignore: must_be_immutable
class CustomUser extends Equatable {
  String uid;
  String name;
  String email;
  DateTime birthday;
  int point = 0;
  Membership membership = Membership.Bronze;
  List<String> favoriteProducts = [];
  bool isAdmin = false;

  bool subscribeToNotifications = true;
  int totalOrders = 0;

  CustomUser({
    @required this.uid,
    @required this.name,
    @required this.email,
    @required this.birthday,
    this.isAdmin,
    this.favoriteProducts,
    this.subscribeToNotifications,
  });

  @override
  List<Object> get props => [];

  bool isProductFavorited(String productId) =>
      favoriteProducts.contains(productId);
}
