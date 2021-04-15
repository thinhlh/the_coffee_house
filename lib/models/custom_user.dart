import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:the_coffee_house/models/membership.dart';

class CustomUser {
  String uid;
  String name;
  String email;
  DateTime birthday;
  int point = 0;
  Membership membership = Membership.Bronze;
  List<String> favoriteProducts = [];

  CustomUser({
    @required this.uid,
    @required this.name,
    @required this.email,
    @required this.birthday,
    this.favoriteProducts,
  });

  CustomUser.fromJson(Map<String, dynamic> json) {
    this.uid = json['uid'];
    this.name = json['name'];
    this.email = json['email'];
    this.birthday = (json['birthday'] as Timestamp).toDate();
    this.point = json['point'];

    switch (json['membership']) {
      case 'Membership.Bronze':
        this.membership = Membership.Bronze;
        break;
      case 'Membership.Silver':
        this.membership = Membership.Silver;
        break;
      case 'Membership.Gold':
        this.membership = Membership.Gold;
        break;
      case 'Membership.Diamond':
        this.membership = Membership.Diamond;
        break;
      default:
        break;
    }
    this.favoriteProducts = json['favoriteProducts'] == null
        ? []
        : (json['favoriteProducts'] as List<dynamic>).cast<String>();
  }

  Map<String, dynamic> toJson() {
    return {
      'name': this.name,
      'email': this.email,
      'birthday': this.birthday,
      'point': this.point,
      'membership': this.membership.toString(),
      'favoriteProducts': this.favoriteProducts,
    };
  }

  String get formattedBirthday => DateFormat('dd/MM/y').format(birthday);
}
