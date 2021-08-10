import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:the/tdd/core/errors/failures.dart';
import 'package:the/tdd/core/usecases/usecase.dart';
import 'package:the/tdd/features/products/domain/entities/product.dart';
import 'package:the/tdd/features/products/domain/repositories/products_repository.dart';
import 'package:the/tdd/features/products/domain/usecases/fetch_products.dart';

class MockProductsRepository extends Mock implements ProductsRepository {}

void main() {
  FetchProducts usecase;
  MockProductsRepository repository;

  setUp(() {
    repository = MockProductsRepository();
    usecase = FetchProducts(repository);
  });

  final List<Product> products = [
    Product(
      id: 'id',
      title: 'title',
      description: 'description',
      imageUrl: 'imageUrl',
      price: 0,
      categoryId: 'categoryId',
    )
  ];

  test('should forward the call from usecase to repository', () async {
    // arrange

    // act
    usecase(NoParams());
    //assert
    verify(repository.fetchProducts());
    verifyNoMoreInteractions(repository);
  });

  test(
      'should return Right of products when repository return Right of products',
      () async {
    // arrange
    when(repository.fetchProducts()).thenAnswer((_) async => Right(products));
    // act
    final result = await usecase(NoParams());
    //assert
    expect(result, Right(products));
  });

  test(
      'should return Left of Connection Failure when repository return Left of connection failure',
      () async {
    // arrange
    when(repository.fetchProducts())
        .thenAnswer((_) async => Left(ConnectionFailure()));
    // act
    final result = await usecase(NoParams());
    //assert
    expect(result, Left(ConnectionFailure()));
  });
}
