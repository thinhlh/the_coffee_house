import 'package:flutter/foundation.dart';

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

  Product.map(Map<String, dynamic> json) {
    this.id = json['id'];
    this.title = json['title'];
    this.description = json['description'];
    this.price = json['price'];
    this.imageUrl = json['imageUrl'];
    this.categoryId = json['categoryId'];
  }
}
