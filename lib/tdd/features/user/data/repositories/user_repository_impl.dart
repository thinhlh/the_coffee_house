import 'package:the/tdd/common/domain/entities/custom_user.dart';
import 'package:the/tdd/core/errors/exceptions.dart';
import 'package:the/tdd/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:the/tdd/features/user/data/datasources/user_remote_data_source.dart';
import 'package:the/tdd/features/user/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource _remoteDataSource;

  UserRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, CustomUser>> fetchUserData() async {
    try {
      final result = await _remoteDataSource.fetchUser();
      return Right(result);
    } on ConnectionException catch (e) {
      return Left(ConnectionFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> toggleFavoriteProduct(
    List<String> productIds,
  ) async {
    try {
      await _remoteDataSource.toggleFavoriteProduct(productIds);
      return Right(null);
    } on ConnectionException {
      return Left(ConnectionFailure());
    }
  }
}
