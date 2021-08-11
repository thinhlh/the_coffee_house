import 'package:flutter/foundation.dart';

class Category {
  String id;
  String title;
  String imageUrl;

  Category({
    @required this.id,
    @required this.title,
    @required this.imageUrl,
  });

  Category.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.title = json['title'];
    this.imageUrl = json['imageUrl'];
  }

  Map<String, Object> toJson() {
    return {
      'title': this.title,
      'imageUrl': this.imageUrl,
    };
  }
}
