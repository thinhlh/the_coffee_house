import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:the/tdd/core/errors/failures.dart';
import 'package:the/tdd/core/usecases/usecase.dart';
import 'package:the/tdd/features/address/domain/repositories/address_repository.dart';

class SaveNewDeliveryDetail
    extends BaseUseCase<void, SaveNewDeliveryDetailParams> {
  AddressRepository _repository;

  SaveNewDeliveryDetail(this._repository);

  @override
  Future<Either<Failure, void>> call(SaveNewDeliveryDetailParams params) =>
      _repository.saveNewDeliveryDetail(params);
}

class SaveNewDeliveryDetailParams extends Equatable {
  final String recipientName;
  final String recipientPhone;
  final String address;
  final String note;

  SaveNewDeliveryDetailParams({
    @required this.recipientName,
    @required this.recipientPhone,
    @required this.address,
    @required this.note,
  });

  @override
  List<Object> get props => [
        recipientName,
        recipientPhone,
        address,
      ];
}
