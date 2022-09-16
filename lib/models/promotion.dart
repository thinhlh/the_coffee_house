import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:the/models/membership.dart';

///Ưu đãi cho khách hàng
class Promotion {
  String id;
  String code;
  String title;
  String description;
  DateTime expiryDate;
  List<Membership> targetCustomer;
  String imageUrl;
  String value;

  Promotion({
    @required this.id,
    @required this.code,
    @required this.title,
    @required this.description,
    @required this.expiryDate,
    @required this.targetCustomer,
    @required this.imageUrl,
    @required this.value,
  });

  Promotion.initialize() {
    this.id = '';
    this.code = '';
    this.title = '';
    this.description = '';
    this.expiryDate = DateTime.now();
    this.targetCustomer = [];
    this.imageUrl = '';
    this.value = value;
  }

  Promotion.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.code = json['code'];
    this.title = json['title'];
    this.expiryDate = json['expiryDate'] == null
        ? DateTime.now()
        : (json['expiryDate'] as Timestamp).toDate();
    this.description = json['description'];
    this.targetCustomer = (json['targetCustomer'] as List<dynamic>)
        .cast<String>()
        .map((string) => parseMembershipFromString(string))
        .toList();
    this.imageUrl = json['imageUrl'];
    this.value = json['value'];
  }

  Map<String, Object> toJson() {
    return {
      'code': this.code,
      'title': this.title,
      'expiryDate': this.expiryDate,
      'description': this.description,
      'targetCustomer': targetCustomer.map((e) => e.valueString()).toList(),
      'imageUrl': this.imageUrl,
      'value': this.value,
    };
  }

  String get formattedExpityDate =>
      DateFormat('dd-MM-yyyy').format(this.expiryDate);
}
