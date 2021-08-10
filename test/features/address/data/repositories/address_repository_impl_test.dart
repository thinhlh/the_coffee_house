import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:the/tdd/core/errors/exceptions.dart';
import 'package:the/tdd/core/errors/failures.dart';
import 'package:the/tdd/features/address/data/datasources/address_local_data_source.dart';
import 'package:the/tdd/features/address/data/models/delivery_detail_model.dart';
import 'package:the/tdd/features/address/data/repositories/address_repository_impl.dart';

class MockAddressLocalDataSource extends Mock
    implements AddressLocalDataSource {}

void main() {
  MockAddressLocalDataSource localDataSource;
  AddressRepositoryImpl repository;

  setUp(() {
    localDataSource = MockAddressLocalDataSource();
    repository = AddressRepositoryImpl(localDataSource);
  });

  group('get delivery detail list', () {
    final deliveryDetailModels = [
      DeliveryDetailModel(
        recipientName: 'recipientName',
        recipientPhone: 'recipientPhone',
        address: 'address',
        note: 'note',
      ),
    ];

    test('should forward the call to repository', () async {
      // arrange

      // act
      repository.getDeliveryDetailList();
      //assert
      verify(localDataSource.getDeliveryDetailList());
      verifyNoMoreInteractions(localDataSource);
    });

    test(
        'should return Right of delivery details when local data source return delivery details',
        () async {
      // arrange
      when(localDataSource.getDeliveryDetailList())
          .thenAnswer((_) async => deliveryDetailModels);
      // act
      final result = await repository.getDeliveryDetailList();
      //assert
      expect(result, Right(deliveryDetailModels));
    });

    test(
        'should return Left of local data source failure when local data source throw exception',
        () async {
      // arrange
      when(localDataSource.getDeliveryDetailList())
          .thenThrow(CacheNotFoundException());
      // act
      final result = await repository.getDeliveryDetailList();
      //assert
      expect(result, Left(CacheNotFoundFailure()));
    });
  });
}
