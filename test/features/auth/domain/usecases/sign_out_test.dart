import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:the/tdd/core/errors/failures.dart';
import 'package:the/tdd/core/usecases/usecase.dart';
import 'package:the/tdd/features/auth/domain/repositories/auth_repository.dart';
import 'package:the/tdd/features/auth/domain/usecases/sign_out.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  MockAuthRepository repository;
  SignOut signOut;

  setUp(() {
    repository = MockAuthRepository();
    signOut = SignOut(repository);
  });

  test('should forward the call to repository', () async {
    // arrange

    // act
    signOut(NoParams());
    //assert
    verify(repository.signOut());
    verifyNoMoreInteractions(repository);
  });

  test('should return Right when sign out is successful', () async {
    // arrange
    when(repository.signOut()).thenAnswer((_) async => Right(null));
    // act
    final result = await signOut(NoParams());
    //assert
    expect(result, isA<Right>());
  });

  test('should return Left when sign out is unsuccessful', () async {
    // arrange
    when(repository.signOut())
        .thenAnswer((_) async => Left(ConnectionFailure()));
    // act
    final result = await signOut(NoParams());
    //assert
    expect(result, Left(ConnectionFailure()));
  });
}
