import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:the/tdd/common/domain/entities/custom_user.dart';
import 'package:the/tdd/core/errors/failures.dart';
import 'package:the/tdd/features/auth/domain/repositories/auth_repository.dart';
import 'package:the/tdd/features/auth/domain/usecases/sign_in_with_email_and_password.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  MockAuthRepository repository;
  SignInWithEmailAndPassword usecase;

  setUp(() {
    repository = MockAuthRepository();
    usecase = SignInWithEmailAndPassword(repository);
  });

  final signInParams = SignInParams(
    email: 'email',
    password: 'password',
  );

  final user = CustomUser(
    uid: '',
    name: 'name',
    email: 'email',
    birthday: DateTime.now(),
  );

  final String authExceptionCode = '';

  test('should usecase forward the call to repository', () async {
    // arrange

    // act
    usecase(signInParams);
    //assert
    verify(repository.signIn(signInParams));
    verifyNoMoreInteractions(repository);
  });

  test('should get Right of user from the repository', () async {
    // arrange
    when(repository.signIn(any)).thenAnswer((_) async => Right(user));
    // act
    final result = await usecase(signInParams);
    //assert
    expect(result, Right(user));
  });

  test('should get Left of Authentication failure from the repository',
      () async {
    // arrange
    when(repository.signIn(any)).thenAnswer(
      (_) async => Left(AuthenticationFailure(authExceptionCode)),
    );
    // act
    final result = await usecase(signInParams);
    //assert
    expect(result, Left(AuthenticationFailure(authExceptionCode)));
  });

  test('should get Left of Connection failure from the repository', () async {
    // arrange
    when(repository.signIn(any)).thenAnswer(
      (_) async => Left(ConnectionFailure()),
    );
    // act
    final result = await usecase(signInParams);
    //assert
    expect(result, Left(ConnectionFailure()));
  });
}
