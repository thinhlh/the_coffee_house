import 'package:dartz/dartz.dart';
import 'package:the/tdd/core/errors/failures.dart';
import 'package:the/tdd/features/order/domain/usecases/add_order.dart';

abstract class OrderRepository {
  Future<Either<Failure, void>> addOrder(AddOrderParams orderParams);
}
