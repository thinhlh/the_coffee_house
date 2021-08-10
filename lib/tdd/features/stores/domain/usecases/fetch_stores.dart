import 'package:the/tdd/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:the/tdd/core/usecases/usecase.dart';
import 'package:the/tdd/features/stores/domain/entities/store.dart';
import 'package:the/tdd/features/stores/domain/repositories/stores_repository.dart';

class FetchStores extends BaseUseCase<List<Store>, NoParams> {
  StoresRepository _repository;
  FetchStores(this._repository);

  @override
  Future<Either<Failure, List<Store>>> call(NoParams params) =>
      _repository.fetchStores();
}
