import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:the/tdd/core/errors/failures.dart';
import 'package:the/tdd/core/usecases/usecase.dart';
import 'package:the/tdd/features/address/domain/repositories/address_repository.dart';
import 'package:the/tdd/features/address/domain/usecases/get_latest_take_away_location.dart';

class MockAddressRepository extends Mock implements AddressRepository {}

void main() {
  MockAddressRepository repository;
  GetLatestTakeAwayLocation usecase;

  setUp(() {
    repository = MockAddressRepository();
    usecase = GetLatestTakeAwayLocation(repository);
  });

  final takeAwayLocation = 'store-id';

  test('should forward the call to repository', () async {
    // arrange

    // act
    usecase(NoParams());
    //assert
    verify(repository.getLatestTakeAwayLocation());
    verifyNoMoreInteractions(repository);
  });

  test(
      'should return Right of latest take away location when repository return Right of latest takeaway location',
      () async {
    // arrange
    when(repository.getLatestTakeAwayLocation())
        .thenAnswer((_) async => Right(takeAwayLocation));
    // act
    final result = await usecase(NoParams());
    //assert
    expect(result, Right(takeAwayLocation));
  });

  test(
      'should return Left of cache not found failure when repository return Left of cache not found failure',
      () async {
    // arrange
    when(repository.getLatestTakeAwayLocation())
        .thenAnswer((_) async => Left(CacheNotFoundFailure()));
    // act
    final result = await usecase(NoParams());
    //assert
    expect(result, Left(CacheNotFoundFailure()));
  });
}
