import 'package:the/tdd/features/stores/data/datasources/stores_remote_data_source.dart';
import 'package:the/tdd/features/stores/domain/entities/store.dart';
import 'package:the/tdd/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:the/tdd/features/stores/domain/repositories/stores_repository.dart';

class StoresRepositoryImpl implements StoresRepository {
  final StoresRemoteDataSource _remoteDataSource;
  StoresRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<Store>>> fetchStores() async {
    try {
      return Right(await _remoteDataSource.fetchStores());
    } on Exception {
      return Left(ConnectionFailure());
    }
  }
}
