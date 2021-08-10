import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the/tdd/core/errors/exceptions.dart';
import 'package:the/tdd/features/products/data/models/category_model.dart';

abstract class CategoriesRemoteDataSource {
  Future<List<CategoryModel>> fetchCategories();
}

class CategoriesRemoteDataSourceImpl implements CategoriesRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Future<List<CategoryModel>> fetchCategories() async {
    try {
      final result = await _firestore
          .collection('categories')
          .get()
          .timeout(Duration(seconds: 45));

      return result.docs
          .map((documentSnapshot) => CategoryModel.fromMap(
              documentSnapshot.data()
                ..addEntries([MapEntry('id', documentSnapshot.id)])))
          .toList();
    } on TimeoutException {
      throw ConnectionException();
    }
  }
}
