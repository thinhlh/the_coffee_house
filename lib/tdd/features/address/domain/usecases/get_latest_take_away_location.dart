import 'package:the/tdd/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:the/tdd/core/usecases/usecase.dart';
import 'package:the/tdd/features/address/domain/repositories/address_repository.dart';

class GetLatestTakeAwayLocation extends BaseUseCase<String, NoParams> {
  final AddressRepository _repository;

  GetLatestTakeAwayLocation(this._repository);

  @override
  Future<Either<Failure, String>> call(NoParams params) =>
      _repository.getLatestTakeAwayLocation();
}
