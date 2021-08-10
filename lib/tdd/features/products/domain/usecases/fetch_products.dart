import 'package:the/tdd/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:the/tdd/core/usecases/usecase.dart';
import 'package:the/tdd/features/products/domain/entities/product.dart';
import 'package:the/tdd/features/products/domain/repositories/products_repository.dart';

class FetchProducts extends BaseUseCase<List<Product>, NoParams> {
  final ProductsRepository _repository;

  FetchProducts(this._repository);

  @override
  Future<Either<Failure, List<Product>>> call(NoParams params) =>
      _repository.fetchProducts();
}
