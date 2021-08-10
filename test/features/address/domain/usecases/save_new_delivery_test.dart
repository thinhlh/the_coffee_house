import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the/tdd/core/errors/failures.dart';
import 'package:mockito/mockito.dart';
import 'package:the/tdd/features/address/domain/repositories/address_repository.dart';
import 'package:the/tdd/features/address/domain/usecases/save_new_delivery_detail.dart';

class MockAddressDetailRepository extends Mock implements AddressRepository {}

void main() {
  MockAddressDetailRepository repository;
  SaveNewDeliveryDetail usecase;

  setUp(() {
    repository = MockAddressDetailRepository();
    usecase = SaveNewDeliveryDetail(repository);
  });

  final saveNewAddressParams = SaveNewDeliveryDetailParams(
    recipientName: 'recipientName',
    recipientPhone: 'recipientPhone',
    address: 'address',
    note: 'note',
  );

  test('should forward the call to repository', () async {
    // arrange

    // act
    usecase(saveNewAddressParams);
    //assert
    verify(repository.saveNewDeliveryDetail(saveNewAddressParams));
    verifyNoMoreInteractions(repository);
  });

  test('should return Right if repository return Right', () async {
    // arrange
    when(repository.saveNewDeliveryDetail(any))
        .thenAnswer((_) async => Right(null));
    // act
    final result = await usecase(saveNewAddressParams);
    //assert
    expect(result, Right(null));
  });

  test(
      'should return Left of LocalDataSource failure when repository return Left of Local Data Source Failure',
      () async {
    // arrange
    when(repository.saveNewDeliveryDetail(any))
        .thenAnswer((_) async => Left(LocalDataSourceFailure()));
    // act
    final result = await usecase(saveNewAddressParams);
    //assert
    expect(result, Left(LocalDataSourceFailure()));
  });
}
