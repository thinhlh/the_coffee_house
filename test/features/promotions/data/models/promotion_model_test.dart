import 'package:flutter_test/flutter_test.dart';
import 'package:the/tdd/common/domain/entities/membership.dart';
import 'package:the/tdd/features/promotion/data/models/promotion_model.dart';
import 'package:the/tdd/features/promotion/domain/entities/promotion.dart';

void main() {
  final DateTime now = DateTime.now();
  final promotionModel = PromotionModel(
    id: 'id',
    code: 'code',
    title: 'title',
    description: 'description',
    expiryDate: now,
    imageUrl: 'imageUrl',
    value: 'value',
    targetCustomers: [
      Membership.Bronze,
      Membership.Gold,
    ],
  );

  final Map<String, dynamic> mappedPromotion = {
    'id': 'id',
    'code': 'code',
    'title': 'title',
    'description': 'description',
    'expiryDate': now,
    'imageUrl': 'imageUrl',
    'value': 'value',
    'targetCustomer': ['Bronze', 'Gold'],
  };

  test('should promotion model is a subclass of promotion', () async {
    // arrange

    // act

    //assert
    expect(promotionModel, isA<Promotion>());
  });

  test('should to map return valid map', () async {
    // arrange

    // act
    final result = promotionModel.toMap;
    //assert
    expect(result, {...mappedPromotion}..remove('id'));
  });

  test('should parse to valid object from a map', () async {
    // arrange

    // act
    final result = PromotionModel.fromMap(mappedPromotion);
    //assert
    expect(result, promotionModel);
  });
}
