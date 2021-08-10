import 'package:the/tdd/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:the/tdd/core/usecases/usecase.dart';
import 'package:the/tdd/features/address/domain/entities/delivery_detail.dart';
import 'package:the/tdd/features/address/domain/repositories/address_repository.dart';

class GetDeliveryDetailList
    extends BaseUseCase<List<DeliveryDetail>, NoParams> {
  final AddressRepository _repository;
  GetDeliveryDetailList(this._repository);

  @override
  Future<Either<Failure, List<DeliveryDetail>>> call(NoParams params) =>
      _repository.getDeliveryDetailList();
}
