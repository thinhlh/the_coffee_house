import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:the/tdd/core/errors/exceptions.dart';
import 'package:the/tdd/core/errors/failures.dart';
import 'package:the/tdd/core/usecases/usecase.dart';
import 'package:the/tdd/features/address/domain/entities/delivery_detail.dart';
import 'package:the/tdd/features/address/domain/repositories/address_repository.dart';
import 'package:the/tdd/features/address/domain/usecases/get_latest_delivery_detail.dart';

class MockAddressRepository extends Mock implements AddressRepository {}

void main() {
  MockAddressRepository repository;
  GetLatestDeliveryDetail usecase;

  setUp(() {
    repository = MockAddressRepository();
    usecase = GetLatestDeliveryDetail(repository);
  });

  final deliveryDetail = DeliveryDetail(
    recipientName: 'recipientName',
    recipientPhone: 'recipientPhone',
    address: 'address',
    note: 'note',
  );

  test('should forward the call to repository', () async {
    // arrange

    // act
    usecase(NoParams());
    //assert
    verify(repository.getLatestDeliveryDetail());
    verifyNoMoreInteractions(repository);
  });

  test(
      'should return Right of latest delivery detail when repository return Right of latest delivery details',
      () async {
    // arrange
    when(repository.getLatestDeliveryDetail())
        .thenAnswer((_) async => Right(deliveryDetail));
    // act
    final result = await usecase(NoParams());
    //assert
    expect(result, Right(deliveryDetail));
  });

  test(
      'should return Left of cache not found failure when repository return Left of cache not found failure',
      () async {
    // arrange
    when(repository.getLatestDeliveryDetail())
        .thenAnswer((_) async => Left(CacheNotFoundFailure()));
    // act
    final result = await usecase(NoParams());
    //assert
    expect(result, Left(CacheNotFoundFailure()));
  });
}
