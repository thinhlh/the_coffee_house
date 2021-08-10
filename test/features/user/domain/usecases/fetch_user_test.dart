import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:the/tdd/common/domain/entities/custom_user.dart';
import 'package:the/tdd/core/errors/failures.dart';
import 'package:the/tdd/core/usecases/usecase.dart';
import 'package:the/tdd/features/user/domain/repositories/user_repository.dart';
import 'package:the/tdd/features/user/domain/usecases/fetch_user.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  FetchUser usecase;
  MockUserRepository repository;

  setUp(() {
    repository = MockUserRepository();
    usecase = FetchUser(repository);
  });

  final user = CustomUser(
    uid: 'uid',
    name: 'name',
    email: 'email',
    birthday: DateTime.now(),
  );

  test('should forward the call to repository', () async {
    // arrange

    // act
    usecase(NoParams());
    //assert
    verify(repository.fetchUserData());
    verifyNoMoreInteractions(repository);
  });

  group('should forward the returned object of repository to upper layer', () {
    test('should return Right of User like repository', () async {
      // arrange
      when(repository.fetchUserData()).thenAnswer((_) async => Right(user));
      // act
      final result = await usecase(NoParams());
      //assert
      expect(result, Right(user));
    });

    test('should return Left of Failure like repository if fetching error',
        () async {
      // arrange
      when(repository.fetchUserData()).thenAnswer(
        (_) async => Left(ConnectionFailure()),
      );
      // act
      final result = await usecase(NoParams());
      //assert
      expect(result, Left(ConnectionFailure()));
    });
  });
}
