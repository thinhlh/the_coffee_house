import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:the/tdd/core/errors/failures.dart';
import 'package:the/tdd/core/usecases/usecase.dart';
import 'package:the/tdd/features/address/domain/entities/delivery_detail.dart';
import 'package:the/tdd/features/address/domain/repositories/address_repository.dart';
import 'package:the/tdd/features/address/domain/usecases/get_delivery_detail_list.dart';

class MockAddressRepository extends Mock implements AddressRepository {}

void main() {
  MockAddressRepository repository;
  GetDeliveryDetailList usecase;

  setUp(() {
    repository = MockAddressRepository();
    usecase = GetDeliveryDetailList(repository);
  });

  final deliveryDetails = [
    DeliveryDetail(
      recipientName: 'recipientName',
      recipientPhone: 'recipientPhone',
      address: 'address',
      note: 'note',
    ),
  ];

  test('should forward the call to repository', () async {
    // arrange

    // act
    usecase(NoParams());
    //assert
    verify(repository.getDeliveryDetailList());
    verifyNoMoreInteractions(repository);
  });

  test(
      'should return Right of delivery details when repository return Right of delivery detail',
      () async {
    // arrange
    when(repository.getDeliveryDetailList())
        .thenAnswer((_) async => Right(deliveryDetails));
    // act
    final result = await usecase(NoParams());
    //assert
    expect(result, Right(deliveryDetails));
  });

  test(
      'should return Left of local data source failure when repository return Left of local data source failure',
      () async {
    // arrange
    when(repository.getDeliveryDetailList())
        .thenAnswer((_) async => Left(LocalDataSourceFailure()));
    // act
    final result = await usecase(NoParams());
    //assert
    expect(result, Left(LocalDataSourceFailure()));
  });
}
