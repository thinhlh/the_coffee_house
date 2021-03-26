import 'package:flutter/foundation.dart';

class User {
  String uid;
  String name;
  String email;
  DateTime birthday;
  Map<String, bool> favoriteProducts;

  User({
    @required this.uid,
    @required this.name,
    @required this.email,
    @required this.birthday,
    this.favoriteProducts,
  });
}
