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
}
