import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class Product extends Equatable {
  String id;
  String title;
  String description;
  String imageUrl;
  int price;
  String categoryId;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.imageUrl,
    @required this.price,
    @required this.categoryId,
  });

  @override
  List<Object> get props => [this.id];
}
