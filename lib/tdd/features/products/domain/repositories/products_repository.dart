import 'package:dartz/dartz.dart';
import 'package:the/tdd/core/errors/failures.dart';
import 'package:the/tdd/features/products/domain/entities/category.dart';
import 'package:the/tdd/features/products/domain/entities/product.dart';

abstract class ProductsRepository {
  Future<Either<Failure, List<Product>>> fetchProducts();
  Future<Either<Failure, List<Category>>> fetchCategories();
}
