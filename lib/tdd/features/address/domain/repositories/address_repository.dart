import 'package:dartz/dartz.dart';
import 'package:the/tdd/core/errors/failures.dart';
import 'package:the/tdd/features/address/domain/entities/delivery_detail.dart';
import 'package:the/tdd/features/address/domain/usecases/save_new_delivery_detail.dart';

abstract class AddressRepository {
  Future<Either<Failure, DeliveryDetail>> getLatestDeliveryDetail();

  Future<Either<Failure, String>> getLatestTakeAwayLocation();

  Future<Either<Failure, List<DeliveryDetail>>> getDeliveryDetailList();

  Future<Either<Failure, void>> saveNewDeliveryDetail(
    SaveNewDeliveryDetailParams params,
  );
}
