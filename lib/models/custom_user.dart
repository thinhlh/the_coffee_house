import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class CustomUser {
  String uid;
  String name;
  String email;
  DateTime birthday;
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
    this.favoriteProducts = json['favoriteProducts'] == null
        ? []
        : (json['favoriteProducts'] as List<dynamic>).cast<String>();
  }
}
