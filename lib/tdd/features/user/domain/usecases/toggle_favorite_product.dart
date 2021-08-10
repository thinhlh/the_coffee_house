import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:the/tdd/core/errors/failures.dart';
import 'package:the/tdd/core/usecases/usecase.dart';
import 'package:the/tdd/features/user/domain/repositories/user_repository.dart';

class ToggleFavoriteProduct
    extends BaseUseCase<void, ToggleFavoriteProductParams> {
  final UserRepository _repository;
  ToggleFavoriteProduct(this._repository);

  @override
  Future<Either<Failure, void>> call(ToggleFavoriteProductParams params) =>
      _repository.toggleFavoriteProduct(params.productIds);
}

class ToggleFavoriteProductParams extends Equatable {
  final List<String> productIds;
  ToggleFavoriteProductParams(this.productIds);

  @override
  List<Object> get props => [this.productIds];
}
