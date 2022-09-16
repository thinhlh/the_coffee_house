import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import 'membership.dart';

class CustomUser {
  String uid;
  String name;
  String email;
  DateTime birthday;
  int point = 0;
  Membership membership = Membership.Bronze;
  List<String> favoriteProducts = [];
  bool isAdmin = false;

  DateTime registerDate;
  DateTime lastSignIn;
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

  CustomUser.fromJson(Map<String, dynamic> json) {
    this.uid = json['uid'];
    this.name = json['name'];
    this.email = json['email'];
    this.birthday = json['birthday'] == null
        ? DateTime.now()
        : (json['birthday'] as Timestamp).toDate();
    this.point = json['point'] ?? 0;

    switch (json['membership']) {
      case 'Bronze':
        this.membership = Membership.Bronze;
        break;
      case 'Silver':
        this.membership = Membership.Silver;
        break;
      case 'Gold':
        this.membership = Membership.Gold;
        break;
      case 'Diamond':
        this.membership = Membership.Diamond;
        break;
      default:
        break;
    }
    this.isAdmin = json['admin'] ?? false;
    this.favoriteProducts = json['favoriteProducts'] == null
        ? []
        : (json['favoriteProducts'] as List<dynamic>).cast<String>();
    this.subscribeToNotifications = json['subscribeToNotifications'] ?? true;
    this.totalOrders = json['totalOrders'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': this.name,
      'email': this.email,
      'birthday': this.birthday,
      'point': this.point,
      'membership': this.membership.valueString(),
      'favoriteProducts': this.favoriteProducts,
      'admin': this.isAdmin,
    };
  }

  String get formattedBirthday => DateFormat('dd/MM/y').format(birthday);
}
