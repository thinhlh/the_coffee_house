import 'package:flutter/material.dart';
import 'package:the/tdd/core/errors/exceptions.dart';
import 'package:the/tdd/features/products/data/datasources/categories_remote_data_source.dart';
import 'package:the/tdd/features/products/data/datasources/products_remote_data_source.dart';
import 'package:the/tdd/features/products/domain/entities/category.dart';
import 'package:the/tdd/features/products/domain/entities/product.dart';
import 'package:the/tdd/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:the/tdd/features/products/domain/repositories/products_repository.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsRemoteDataSource productsRemoteDataSource;
  final CategoriesRemoteDataSource categoriesRemoteDataSource;

  ProductsRepositoryImpl({
    @required this.productsRemoteDataSource,
    @required this.categoriesRemoteDataSource,
  });

  @override
  Future<Either<Failure, List<Product>>> fetchProducts() async {
    try {
      final result = await productsRemoteDataSource.fetchProducts();
      return Right(result);
    } on ConnectionException {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, List<Category>>> fetchCategories() async {
    try {
      final result = await categoriesRemoteDataSource.fetchCategories();
      return Right(result);
    } on ConnectionException {
      return Left(ConnectionFailure());
    }
  }
}
