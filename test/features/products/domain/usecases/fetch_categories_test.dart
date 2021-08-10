import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:the/tdd/core/errors/failures.dart';
import 'package:the/tdd/core/usecases/usecase.dart';
import 'package:the/tdd/features/products/domain/entities/category.dart';
import 'package:the/tdd/features/products/domain/repositories/products_repository.dart';
import 'package:the/tdd/features/products/domain/usecases/fetch_categories.dart';

class MockProductsRepository extends Mock implements ProductsRepository {}

void main() {
  MockProductsRepository repository;
  FetchCategories usecase;

  setUp(() {
    repository = MockProductsRepository();
    usecase = FetchCategories(repository);
  });

  final List<Category> categories = [
    Category(id: 'id', title: 'title', imageUrl: 'imageUrl'),
  ];

  test('should forward the call to repository', () async {
    // arrange

    // act
    usecase(NoParams());
    //assert
    verify(repository.fetchCategories());
    verifyNoMoreInteractions(repository);
  });

  test(
      'should return Right of categories when repository return Right of categories',
      () async {
    // arrange
    when(repository.fetchCategories())
        .thenAnswer((_) async => Right(categories));
    // act
    final result = await usecase(NoParams());
    //assert
    expect(result, Right(categories));
  });

  test(
      'should return Left of Connection Failure when repository return Left of Connection failure',
      () async {
    // arrange
    when(repository.fetchCategories())
        .thenAnswer((_) async => Left(ConnectionFailure()));
    // act
    final result = await usecase(NoParams());
    //assert
    expect(result, Left(ConnectionFailure()));
  });
}
