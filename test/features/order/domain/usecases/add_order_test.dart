import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:the/tdd/core/errors/failures.dart';
import 'package:the/tdd/features/order/domain/entities/order_method.dart';
import 'package:the/tdd/features/order/domain/repositories/order_repository.dart';
import 'package:the/tdd/features/order/domain/usecases/add_order.dart';

class MockOrderRepository extends Mock implements OrderRepository {}

void main() {
  MockOrderRepository repository;
  AddOrder usecase;

  setUp(() {
    repository = MockOrderRepository();
    usecase = AddOrder(repository);
  });

  final AddOrderParams params = AddOrderParams(
    recipientName: '',
    orderValue: 0,
    orderMethod: OrderMethod.Delivery,
    promotionId: '',
    orderAddress: 'orderAddress',
    cartItems: [],
  );

  test('should forward the call from usecase to repository', () async {
    // arrange

    // act
    usecase(params);
    //assert
    verify(repository.addOrder(params));
    verifyNoMoreInteractions(repository);
  });

  test('should usecase return Right when add order complete', () async {
    // arrange
    when(repository.addOrder(any)).thenAnswer((_) async => Right(null));
    // act
    final result = await usecase(params);
    //assert
    expect(result.isRight(), isTrue);
  });

  test('should usecase return Left of Failure when add order is incompleted',
      () async {
    // arrange
    when(repository.addOrder(any))
        .thenAnswer((_) async => Left(ConnectionFailure()));
    // act
    final result = await usecase(params);
    //assert
    expect(result, Left(ConnectionFailure()));
  });
}
