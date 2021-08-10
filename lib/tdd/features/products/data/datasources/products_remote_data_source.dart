import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the/tdd/core/errors/exceptions.dart';
import 'package:the/tdd/features/products/data/models/product_model.dart';

abstract class ProductsRemoteDataSource {
  Future<List<ProductModel>> fetchProducts();
}

class ProductsRemoteDataSourceImpl implements ProductsRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<ProductModel>> fetchProducts() async {
    try {
      final result = await _firestore
          .collection('products')
          .get()
          .timeout(Duration(minutes: 1));

      return result.docs
          .map(
            (documentSnapshot) => ProductModel.fromMap(documentSnapshot.data()
              ..addEntries(
                [MapEntry('id', documentSnapshot.id)],
              )),
          )
          .toList();
    } on TimeoutException {
      throw ConnectionException();
    }
  }
}
