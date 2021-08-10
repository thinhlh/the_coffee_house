import 'package:flutter/foundation.dart';
import 'package:the/tdd/features/products/domain/entities/product.dart';

class ProductModel extends Product {
  ProductModel({
    @required String id,
    @required String title,
    @required String description,
    @required String imageUrl,
    @required int price,
    @required String categoryId,
  }) : super(
          id: id,
          title: title,
          description: description,
          imageUrl: imageUrl,
          price: price,
          categoryId: categoryId,
        );

  Map<String, Object> toMap() {
    return {
      'title': this.title,
      'description': this.description,
      'price': this.price,
      'imageUrl': this.imageUrl,
      'categoryId': this.categoryId,
    };
  }

  ProductModel.fromMap(Map<String, Object> map) {
    this.id = map['id'];
    this.title = map['title'];
    this.description = map['description'];
    this.price = map['price'];
    this.imageUrl = map['imageUrl'];
    this.categoryId = map['categoryId'];
  }
}
