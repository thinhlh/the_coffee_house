import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class Product {
  String id;
  String title;
  String description;
  double price;
  String imageUrl;
  String categoryId;

  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    @required this.categoryId,
    this.isFavorite = false,
  });

  Product.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.title = json['title'];
    this.description = json['description'];
    this.price = json['price'] + .0;
    this.imageUrl = json['imageUrl'];
    this.categoryId = json['categoryId'];
  }

  Map<String, dynamic> toJson() {
    return {
      'title': this.title,
      'description': this.description,
      'price': this.price,
      'imageUrl': this.imageUrl,
      'categoryId': this.categoryId,
    };
  }

  String get formattedPrice => NumberFormat.currency(
        locale: 'vi-VN',
        decimalDigits: 0,
      ).format(price);
}
