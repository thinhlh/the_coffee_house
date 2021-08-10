import 'package:the/tdd/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:the/tdd/core/usecases/usecase.dart';
import 'package:the/tdd/features/promotion/domain/entities/promotion.dart';
import 'package:the/tdd/features/promotion/domain/repositories/promotions_repository.dart';

class FetchPromotions extends BaseUseCase<List<Promotion>, NoParams> {
  final PromotionsRepository _repository;
  FetchPromotions(this._repository);

  @override
  Future<Either<Failure, List<Promotion>>> call(NoParams params) =>
      _repository.fetchPromotions();
}
