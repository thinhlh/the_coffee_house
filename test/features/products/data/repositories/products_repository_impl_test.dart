import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:the/tdd/core/errors/exceptions.dart';
import 'package:the/tdd/core/errors/failures.dart';
import 'package:the/tdd/features/products/data/datasources/categories_remote_data_source.dart';
import 'package:the/tdd/features/products/data/datasources/products_remote_data_source.dart';
import 'package:the/tdd/features/products/data/models/category_model.dart';
import 'package:the/tdd/features/products/data/models/product_model.dart';
import 'package:the/tdd/features/products/data/repositories/products_repository_impl.dart';

class MockProductsRemoteDataSource extends Mock
    implements ProductsRemoteDataSource {}

class MockCategoriesRemoteDataSource extends Mock
    implements CategoriesRemoteDataSource {}

void main() {
  MockProductsRemoteDataSource productsRemoteDataSource;
  MockCategoriesRemoteDataSource categoriesRemoteDataSource;
  ProductsRepositoryImpl repository;

  setUp(() {
    productsRemoteDataSource = MockProductsRemoteDataSource();
    categoriesRemoteDataSource = MockCategoriesRemoteDataSource();
    repository = ProductsRepositoryImpl(
        productsRemoteDataSource: productsRemoteDataSource,
        categoriesRemoteDataSource: categoriesRemoteDataSource);
  });

  group('products', () {
    final products = [
      ProductModel(
        id: 'id',
        title: 'title',
        description: 'description',
        imageUrl: 'imageUrl',
        price: 0,
        categoryId: '',
      ),
    ];

    test('should forward the call from repository to remote data source',
        () async {
      // arrange

      // act
      repository.fetchProducts();
      //assert
      verify(productsRemoteDataSource.fetchProducts());
      verifyNoMoreInteractions(productsRemoteDataSource);
    });

    test('should return a Right of product models when fetching complete',
        () async {
      // arrange
      when(productsRemoteDataSource.fetchProducts())
          .thenAnswer((_) async => products);
      // act
      final result = await repository.fetchProducts();
      //assert
      expect(result, Right(products));
    });

    test('should return a Left of Failure when fetching error', () async {
      // arrange
      when(productsRemoteDataSource.fetchProducts())
          .thenThrow(ConnectionException());
      // act
      final result = await repository.fetchProducts();
      //assert
      expect(result, Left(ConnectionFailure()));
    });
  });

  group('categories', () {
    final List<CategoryModel> categories = [
      CategoryModel(
        id: 'id',
        title: 'title',
        imageUrl: 'imageUrl',
      ),
    ];
    test('should forward the call to remote data source', () async {
      // arrange

      // act
      repository.fetchCategories();
      //assert
      verify(categoriesRemoteDataSource.fetchCategories());
      verifyNoMoreInteractions(categoriesRemoteDataSource);
    });

    test(
        'should return Right of categories when remote data source return categories',
        () async {
      // arrange
      when(categoriesRemoteDataSource.fetchCategories())
          .thenAnswer((_) async => categories);
      // act
      final result = await repository.fetchCategories();
      //assert
      expect(result, Right(categories));
    });

    test(
        'should return Left of Connection failure when remote data source throw Connection exception',
        () async {
      // arrange
      when(categoriesRemoteDataSource.fetchCategories())
          .thenThrow(ConnectionException());
      // act
      final result = await repository.fetchCategories();
      //assert
      expect(result, Left(ConnectionFailure()));
    });
  });
}
