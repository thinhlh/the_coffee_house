import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/mockito.dart';
import 'package:the/tdd/core/errors/failures.dart';
import 'package:the/tdd/core/usecases/usecase.dart';
import 'package:the/tdd/features/stores/domain/entities/store.dart';
import 'package:the/tdd/features/stores/domain/repositories/stores_repository.dart';
import 'package:the/tdd/features/stores/domain/usecases/fetch_stores.dart';

class MockStoresRepository extends Mock implements StoresRepository {}

void main() {
  MockStoresRepository repository;
  FetchStores usecase;

  setUp(() {
    repository = MockStoresRepository();
    usecase = FetchStores(repository);
  });

  final stores = [
    Store(
      id: 'id',
      address: 'address',
      coordinate: LatLng(0, 0),
      name: 'name',
      imageUrl: 'imageUrl',
    ),
  ];

  test('should forward the call to repository', () async {
    // arrange

    // act
    usecase(NoParams());
    //assert
    verify(repository.fetchStores());
    verifyNoMoreInteractions(repository);
  });

  test('should return Right of stores when repository return Right of stores',
      () async {
    // arrange
    when(repository.fetchStores()).thenAnswer((_) async => Right(stores));
    // act
    final result = await usecase(NoParams());
    //assert
    expect(result, Right(stores));
  });

  test('should return Left of Failure when repository return Left of Failure',
      () async {
    // arrange
    when(repository.fetchStores())
        .thenAnswer((_) async => Left(ConnectionFailure()));
    // act
    final result = await usecase(NoParams());
    //assert
    expect(result, Left(ConnectionFailure()));
  });
}
