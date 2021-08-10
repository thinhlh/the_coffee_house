import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/mockito.dart';
import 'package:the/tdd/core/errors/exceptions.dart';
import 'package:the/tdd/core/errors/failures.dart';
import 'package:the/tdd/features/stores/data/datasources/stores_remote_data_source.dart';
import 'package:the/tdd/features/stores/data/models/store_model.dart';
import 'package:the/tdd/features/stores/data/repositories/stores_repository_impl.dart';

class MockStoresRemoteDataSource extends Mock
    implements StoresRemoteDataSource {}

void main() {
  MockStoresRemoteDataSource remoteDataSource;
  StoresRepositoryImpl repository;

  setUp(() {
    remoteDataSource = MockStoresRemoteDataSource();
    repository = StoresRepositoryImpl(remoteDataSource);
  });

  final stores = [
    StoreModel(
      id: 'id',
      address: 'address',
      name: 'name',
      coordinate: LatLng(0, 0),
      imageUrl: 'imageUrl',
    ),
  ];

  test('should forward the call from repository to remote data source',
      () async {
    // arrange

    // act
    repository.fetchStores();
    //assert
    verify(remoteDataSource.fetchStores());
    verifyNoMoreInteractions(remoteDataSource);
  });

  test(
      'should return Right of stores when remote data sources return list of stores',
      () async {
    // arrange
    when(remoteDataSource.fetchStores()).thenAnswer((_) async => stores);
    // act
    final result = await repository.fetchStores();
    //assert
    expect(result, Right(stores));
  });

  test(
      'should return Left of failure when remote data source fetch stores is timed out or failed',
      () async {
    // arrange
    when(remoteDataSource.fetchStores()).thenThrow(ConnectionException());
    // act
    final result = await repository.fetchStores();
    //assert
    expect(result, Left(ConnectionFailure()));
  });
}
