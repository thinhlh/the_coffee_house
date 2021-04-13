import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

///Ưu đãi cho khách hàng
class Coupon {
  String code;
  String title;
  DateTime expiryDate;
  List<String> conditions;
  String imageUrl;

  Coupon({
    @required this.code,
    @required this.title,
    @required this.expiryDate,
    @required this.conditions,
    @required this.imageUrl,
  });

  Coupon.fromJson(Map<String, dynamic> json) {
    this.code = json['code'];
    this.title = json['title'];
    this.expiryDate = (json['expiryDate'] as Timestamp).toDate();
    this.conditions = json['conditions'] == null
        ? []
        : (json['conditions'] as List<dynamic>).cast<String>();
    this.imageUrl = json['imageUrl'];
  }
}
