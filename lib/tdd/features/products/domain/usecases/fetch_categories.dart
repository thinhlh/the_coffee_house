import 'package:the/tdd/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:the/tdd/core/usecases/usecase.dart';
import 'package:the/tdd/features/products/domain/entities/category.dart';
import 'package:the/tdd/features/products/domain/repositories/products_repository.dart';

class FetchCategories extends BaseUseCase<List<Category>, NoParams> {
  final ProductsRepository _repository;

  FetchCategories(this._repository);

  @override
  Future<Either<Failure, List<Category>>> call(NoParams params) =>
      _repository.fetchCategories();
}
