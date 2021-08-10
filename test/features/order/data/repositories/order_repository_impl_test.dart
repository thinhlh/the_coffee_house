import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:the/tdd/core/errors/exceptions.dart';
import 'package:the/tdd/core/errors/failures.dart';
import 'package:the/tdd/features/order/data/datasources/order_remote_data_source.dart';
import 'package:the/tdd/features/order/data/models/order_model.dart';
import 'package:the/tdd/features/order/data/repositories/order_repository_impl.dart';
import 'package:the/tdd/features/order/domain/entities/order_method.dart';
import 'package:the/tdd/features/order/domain/usecases/add_order.dart';

class MockOrderRemoteDataSource extends Mock implements OrderRemoteDataSource {}

void main() {
  MockOrderRemoteDataSource remoteDataSource;
  OrderRepositoryImpl repository;

  setUp(() {
    remoteDataSource = MockOrderRemoteDataSource();
    repository = OrderRepositoryImpl(remoteDataSource);
  });

  final AddOrderParams orderParams = AddOrderParams(
    orderAddress: 'orderAddress',
    orderMethod: OrderMethod.Delivery,
    cartItems: [],
    recipientName: 'recipientName',
    orderValue: 0,
    promotionId: '',
  );

  final OrderModel orderModel = OrderModel(
    orderAddress: 'orderAddress',
    orderMethod: OrderMethod.TakeAway,
    orderValue: 0,
    recipientName: 'recipientName',
    promotionId: 'promotionId',
    recipientPhone: 'recipientPhone',
  );

  test('should forward the call to remote data source', () async {
    // arrange

    // act
    repository.addOrder(orderParams);
    //assert
    verify(remoteDataSource.addOrder(orderModel));
    verifyNoMoreInteractions(remoteDataSource);
  });

  test('should return Right when order is added complete', () async {
    // arrange
    when(remoteDataSource.addOrder(any)).thenAnswer((_) => null);
    // act
    final result = await repository.addOrder(orderParams);
    //assert
    expect(result, Right(null));
  });

  test('should return Left of failure when remote data source throw exception',
      () async {
    // arrange
    when(remoteDataSource.addOrder(any)).thenThrow(ConnectionException());
    // act
    final result = await repository.addOrder(orderParams);
    //assert
    expect(result, Left(ConnectionFailure()));
  });
}
