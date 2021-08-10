import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:the/tdd/common/domain/entities/membership.dart';
import 'package:the/tdd/core/errors/exceptions.dart';
import 'package:the/tdd/core/errors/failures.dart';
import 'package:the/tdd/features/promotion/data/datasources/promotions_remote_datasource.dart';
import 'package:the/tdd/features/promotion/data/models/promotion_model.dart';
import 'package:the/tdd/features/promotion/data/repositories/promotions_repository_impl.dart';

class MockPromotionsRemoteDataSource extends Mock
    implements PromotionsRemoteDataSource {}

void main() {
  MockPromotionsRemoteDataSource remoteDataSource;
  PromotionsRepositoryImpl repository;

  setUp(() {
    remoteDataSource = MockPromotionsRemoteDataSource();
    repository = PromotionsRepositoryImpl(remoteDataSource);
  });

  final promotions = [
    PromotionModel(
      id: 'id',
      code: 'code',
      title: 'title',
      description: 'description',
      expiryDate: DateTime.now(),
      imageUrl: 'imageUrl',
      value: 'value',
      targetCustomers: [Membership.Silver],
    ),
  ];

  test('should forward the call to remote data source', () async {
    // arrange

    // act
    repository.fetchPromotions();
    //assert
    verify(remoteDataSource.fetchPromotions());
    verifyNoMoreInteractions(remoteDataSource);
  });

  test(
      'should return Right of promotions when remote data source return promotions',
      () async {
    // arrange
    when(remoteDataSource.fetchPromotions())
        .thenAnswer((_) async => promotions);
    // act
    final result = await repository.fetchPromotions();
    //assert
    expect(result, Right(promotions));
  });

  test(
      'should return Left of connection failure when remote data source throw Connection exception',
      () async {
    // arrange
    when(remoteDataSource.fetchPromotions()).thenThrow(ConnectionException());
    // act
    final result = await repository.fetchPromotions();

    //assert
    expect(result, Left(ConnectionFailure()));
  });
}
