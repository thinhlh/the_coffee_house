import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:the/tdd/common/domain/entities/custom_user.dart';
import 'package:the/tdd/core/errors/failures.dart';
import 'package:the/tdd/features/auth/domain/repositories/auth_repository.dart';
import 'package:the/tdd/features/auth/domain/usecases/sign_up.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  MockAuthRepository repository;
  SignUp usecase;

  setUp(() {
    repository = MockAuthRepository();
    usecase = SignUp(repository);
  });

  final String authExceptionCode = 'code';
  final signUpParams = SignUpParams(
    email: 'email',
    password: 'password',
    name: 'name',
    birthday: DateTime.now(),
  );
  final user = CustomUser(
    uid: 'uid',
    name: 'name',
    email: 'email',
    birthday: DateTime.now(),
  );

  test('should forward the call to repository', () async {
    // arrange

    // act
    usecase(signUpParams);
    //assert
    verify(repository.signUp(signUpParams));
    verifyNoMoreInteractions(repository);
  });

  test('should return Right of user when successfully sign up', () async {
    // arrange
    when(repository.signUp(any)).thenAnswer((_) async => Right(user));
    // act
    final result = await usecase(signUpParams);
    //assert
    expect(result, Right(user));
  });

  test('should return Left of Authentication failure when sign up unsuccessful',
      () async {
    // arrange
    when(repository.signUp(signUpParams)).thenAnswer(
      (_) async => Left(
        AuthenticationFailure(authExceptionCode),
      ),
    );
    // act
    final result = await usecase(signUpParams);
    //assert
    expect(result, Left(AuthenticationFailure(authExceptionCode)));
  });

  test(
      'should return Left of Connection failure when sign up unsucessful because of unidentified error',
      () async {
    // arrange
    when(repository.signUp(signUpParams)).thenAnswer(
      (_) async => Left(
        ConnectionFailure(),
      ),
    );
    // act
    final result = await usecase(signUpParams);
    //assert
    expect(result, Left(ConnectionFailure()));
  });
}
