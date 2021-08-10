import 'package:the/tdd/features/promotion/data/datasources/promotions_remote_datasource.dart';
import 'package:the/tdd/features/promotion/domain/entities/promotion.dart';
import 'package:the/tdd/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:the/tdd/features/promotion/domain/repositories/promotions_repository.dart';

class PromotionsRepositoryImpl implements PromotionsRepository {
  final PromotionsRemoteDataSource _remoteDataSource;

  PromotionsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<Promotion>>> fetchPromotions() async {
    try {
      final result = await _remoteDataSource.fetchPromotions();
      return Right(result);
    } on Exception {
      return Left(ConnectionFailure());
    }
  }
}
