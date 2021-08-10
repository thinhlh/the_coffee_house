import 'package:flutter_test/flutter_test.dart';
import 'package:the/tdd/features/order/data/models/cart_item_model.dart';
import 'package:the/tdd/features/order/domain/entities/cart_item.dart';

void main() {
  final cartItemModel = CartItemModel(
    productId: 'productId',
    quantity: 0,
    title: 'title',
    note: 'note',
    unitPrice: 0,
  );

  final Map<String, dynamic> mappedValue = {
    'productId': 'productId',
    'quantity': 0,
    'title': 'title',
    'note': 'note',
    'itemPrice': 0
  };

  test('should cart item model is a subclass of cart item', () async {
    // arrange

    // act

    //assert
    expect(cartItemModel, isA<CartItem>());
  });

  test('should toMap return valid map', () async {
    // arrange

    // act
    final result = cartItemModel.toMap();
    //assert
    expect(result, {...mappedValue}..remove('title'));
  });

  test('should parse from Map to valid object', () async {
    // arrange

    // act
    final result = CartItemModel.fromMap(mappedValue);
    //assert
    expect(result, cartItemModel);
  });
}
