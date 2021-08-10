import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:the/tdd/core/errors/failures.dart';
import 'package:the/tdd/features/user/domain/repositories/user_repository.dart';
import 'package:the/tdd/features/user/domain/usecases/toggle_favorite_product.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  MockUserRepository repository;
  ToggleFavoriteProduct usecase;

  setUp(() {
    repository = MockUserRepository();
    usecase = ToggleFavoriteProduct(repository);
  });

  final ToggleFavoriteProductParams params = ToggleFavoriteProductParams([
    'productIds',
  ]);

  test('should forward the call from usecase to repository', () async {
    // arrange

    // act
    usecase(params);
    //assert
    verify(repository.toggleFavoriteProduct(params.productIds));
    verifyNoMoreInteractions(repository);
  });

  test('should return Right if repository return Right object', () async {
    // arrange
    when(repository.toggleFavoriteProduct(any))
        .thenAnswer((_) async => Right(null));
    // act
    final result = await repository.toggleFavoriteProduct(params.productIds);
    //assert
    expect(result.isRight(), isTrue);
  });

  test('should return Left if repository return Left of ConnectionFailure',
      () async {
    // arrange
    when(repository.toggleFavoriteProduct(any))
        .thenAnswer((_) async => Left(ConnectionFailure()));
    // act
    final result = await repository.toggleFavoriteProduct(params.productIds);
    //assert
    expect(result, Left(ConnectionFailure()));
  });
}
