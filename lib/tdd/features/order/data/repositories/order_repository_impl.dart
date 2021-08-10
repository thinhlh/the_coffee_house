import 'package:the/tdd/core/errors/exceptions.dart';
import 'package:the/tdd/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:the/tdd/features/order/data/datasources/order_remote_data_source.dart';
import 'package:the/tdd/features/order/data/models/order_model.dart';
import 'package:the/tdd/features/order/domain/repositories/order_repository.dart';
import 'package:the/tdd/features/order/domain/usecases/add_order.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource _remoteDataSource;

  OrderRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, void>> addOrder(AddOrderParams orderParams) async {
    try {
      final result = await _remoteDataSource.addOrder(
        OrderModel(
          orderAddress: orderParams.orderAddress,
          orderMethod: orderParams.orderMethod,
          orderValue: orderParams.orderValue,
          recipientName: orderParams.recipientName,
          recipientPhone: orderParams.recipientPhone,
          promotionId: orderParams.promotionId,
          cartItems: orderParams.cartItems,
        ),
      );
      return Right(result);
    } on ConnectionException {
      return Left(ConnectionFailure());
    }
  }
}
