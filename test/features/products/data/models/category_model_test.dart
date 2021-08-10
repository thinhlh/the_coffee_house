import 'package:flutter_test/flutter_test.dart';
import 'package:the/tdd/features/products/data/models/category_model.dart';
import 'package:the/tdd/features/products/domain/entities/category.dart';

void main() {
  final CategoryModel category = CategoryModel(
    id: 'id',
    title: 'title',
    imageUrl: 'imageUrl',
  );

  final mappedCategory = {
    'id': 'id',
    'title': 'title',
    'imageUrl': 'imageUrl',
  };

  test('should category model is a subclass of category ', () async {
    expect(category, isA<Category>());
  });

  test('should toMap return valid value', () async {
    // arrange
    // act
    final result = category.toMap();
    //assert
    expect(result, {...mappedCategory}..remove('id'));
  });

  test('should obtain valid category model from the map', () async {
    // arrange

    // act
    final result = CategoryModel.fromMap(mappedCategory);
    //assert
    expect(result, category);
  });
}
