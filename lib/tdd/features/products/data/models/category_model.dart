import 'package:flutter/material.dart';
import 'package:the/tdd/features/products/domain/entities/category.dart';

class CategoryModel extends Category {
  CategoryModel({
    @required String id,
    @required String title,
    @required String imageUrl,
  }) : super(
          id: id,
          title: title,
          imageUrl: imageUrl,
        );

  Map<String, Object> toMap() {
    return {
      'title': this.title,
      'imageUrl': this.imageUrl,
    };
  }

  CategoryModel.fromMap(Map<String, Object> map) {
    this.id = map['id'];
    this.title = map['title'];
    this.imageUrl = map['imageUrl'];
  }
}
