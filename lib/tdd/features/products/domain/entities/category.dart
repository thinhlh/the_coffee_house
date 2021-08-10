import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Category extends Equatable {
  String id;
  String title;
  String imageUrl;

  Category({
    @required this.id,
    @required this.title,
    @required this.imageUrl,
  });

  @override
  List<Object> get props => [this.id];
}
