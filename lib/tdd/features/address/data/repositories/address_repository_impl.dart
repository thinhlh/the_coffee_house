import 'package:the/tdd/core/errors/exceptions.dart';
import 'package:the/tdd/features/address/data/datasources/address_local_data_source.dart';
import 'package:the/tdd/features/address/domain/entities/delivery_detail.dart';
import 'package:the/tdd/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:the/tdd/features/address/domain/repositories/address_repository.dart';
import 'package:the/tdd/features/address/domain/usecases/save_new_delivery_detail.dart';

class AddressRepositoryImpl implements AddressRepository {
  final AddressLocalDataSource _localDataSource;
  AddressRepositoryImpl(this._localDataSource);

  @override
  Future<Either<Failure, List<DeliveryDetail>>> getDeliveryDetailList() async {
    try {
      final result = await _localDataSource.getDeliveryDetailList();
      return Right(result);
    } on CacheNotFoundException {
      return Left(CacheNotFoundFailure());
    }
  }

  @override
  Future<Either<Failure, void>> saveNewDeliveryDetail(
      SaveNewDeliveryDetailParams params) async {
    try {
      await _localDataSource.saveNewDeliveryDetail(params);
      return Right(null);
    } on LocalDataSourceException {
      return Left(LocalDataSourceFailure());
    }
  }

  @override
  Future<Either<Failure, DeliveryDetail>> getLatestDeliveryDetail() async {
    try {
      final result = await _localDataSource.getLatestDeliveryDetail();
      return Right(result);
    } on CacheNotFoundException {
      return Left(CacheNotFoundFailure());
    }
  }

  @override
  Future<Either<Failure, String>> getLatestTakeAwayLocation() async {
    try {
      final result = await _localDataSource.getLatestTakeAwayLocation();
      return Right(result);
    } on CacheNotFoundException {
      return Left(CacheNotFoundFailure());
    }
  }
}
