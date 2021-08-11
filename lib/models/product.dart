import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class Product extends Equatable {
  String id;
  String title;
  String description;
  int price;
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
    this.price = (json['price'] + .0).toInt();
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

  @override
  List<Object> get props => [];
}
