import 'package:dartz/dartz.dart';
import 'package:the/tdd/core/errors/failures.dart';
import 'package:the/tdd/features/stores/domain/entities/store.dart';

abstract class StoresRepository {
  Future<Either<Failure, List<Store>>> fetchStores();
}
