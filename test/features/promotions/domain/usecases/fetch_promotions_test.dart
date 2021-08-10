import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:the/tdd/common/domain/entities/membership.dart';
import 'package:the/tdd/core/errors/failures.dart';
import 'package:the/tdd/core/usecases/usecase.dart';
import 'package:the/tdd/features/promotion/domain/entities/promotion.dart';
import 'package:the/tdd/features/promotion/domain/repositories/promotions_repository.dart';
import 'package:the/tdd/features/promotion/domain/usecases/fetch_promotions.dart';

class MockPromotionsRepository extends Mock implements PromotionsRepository {}

void main() {
  MockPromotionsRepository repository;
  FetchPromotions usecase;

  setUp(() {
    repository = MockPromotionsRepository();
    usecase = FetchPromotions(repository);
  });

  final promotions = [
    Promotion(
      id: 'id',
      code: 'code',
      title: 'title',
      description: 'description',
      expiryDate: DateTime.now(),
      targetCustomers: [Membership.Bronze],
      imageUrl: 'imageUrl',
      value: 'value',
    ),
  ];

  test('should forward the call to repository', () async {
    // arrange

    // act
    usecase(NoParams());
    //assert
    verify(repository.fetchPromotions());
    verifyNoMoreInteractions(repository);
  });

  test(
      'should usecase return Right of promotions when repository return Right of promotions',
      () async {
    // arrange
    when(repository.fetchPromotions())
        .thenAnswer((_) async => Right(promotions));
    // act
    final result = await usecase(NoParams());
    //assert
    expect(result, Right(promotions));
  });

  test('should return Left of failure when repository return Left of failure',
      () async {
    // arrange
    when(repository.fetchPromotions())
        .thenAnswer((_) async => Left(ConnectionFailure()));
    // act
    final result = await usecase(NoParams());
    //assert
    expect(result, Left(ConnectionFailure()));
  });
}
