import 'package:flutter_test/flutter_test.dart';
import 'package:the/tdd/features/products/data/models/product_model.dart';
import 'package:the/tdd/features/products/domain/entities/product.dart';

void main() {
  final ProductModel productModel = ProductModel(
    id: 'id',
    title: 'title',
    description: 'description',
    imageUrl: 'imageUrl',
    price: 0,
    categoryId: 'categoryId',
  );

  final Map<String, Object> mappedModel = {
    'id': 'id',
    'title': 'title',
    'description': 'description',
    'imageUrl': 'imageUrl',
    'price': 0,
    'categoryId': 'categoryId',
  };

  test('should product model is a subclass of product', () async {
    // arrange

    // act

    //assert
    expect(productModel, isA<Product>());
  });

  test('should toMap return valid value', () async {
    // arrange

    // act
    final result = productModel.toMap();
    //assert
    expect(result, {...mappedModel}..remove('id'));
  });

  test('should obtain valid category model from map', () async {
    // arrange

    // act
    final ProductModel result = ProductModel.fromMap(mappedModel);
    //assert
    expect(result, productModel);
  });
}
