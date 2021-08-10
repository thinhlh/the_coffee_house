import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:the/tdd/common/data/models/custom_user_model.dart';
import 'package:the/tdd/core/errors/exceptions.dart';
import 'package:the/tdd/core/errors/failures.dart';
import 'package:the/tdd/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:the/tdd/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:the/tdd/features/auth/domain/usecases/sign_in_with_email_and_password.dart';
import 'package:the/tdd/features/auth/domain/usecases/sign_up.dart';

/// I will skip testing the remote data source cause lack of resources for testing with Firebase functions.
/// Instead, assume that remote data source is correct and it will have 2 cases
/// Return null => if sign in or sign up succeed
/// Throw an exception if error happened

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

void main() {
  AuthRepositoryImpl repository;
  MockAuthRemoteDataSource remoteDataSource;

  setUp(() {
    remoteDataSource = MockAuthRemoteDataSource();
    repository = AuthRepositoryImpl(remoteDataSource);
  });

  final String authErrorCode = 'code';

  final SignInParams signInParams = SignInParams(
    email: 'email',
    password: 'password',
  );

  final SignUpParams signUpParams = SignUpParams(
    email: 'email',
    password: 'password',
    name: 'name',
    birthday: DateTime.now(),
  );

  final userModel = CustomUserModel(
    'uid',
    'name',
    'email',
    DateTime.now(),
  );

  group('should forward the call to appropriate function with the same params',
      () {
    test('should forward sign in params to the remote data source', () async {
      // arrange

      // act
      repository.signIn(signInParams);
      //assert
      verify(remoteDataSource.signIn(signInParams));
      verifyNoMoreInteractions(remoteDataSource);
    });
    test('should forward sign up params to the remote data source', () async {
      // arrange

      // act
      repository.signUp(signUpParams);
      //assert
      verify(remoteDataSource.signUp(signUpParams));
      verifyNoMoreInteractions(remoteDataSource);
    });
    test('should forward sign out call to remote data source', () async {
      // arrange

      // act
      repository.signOut();
      //assert
      verify(remoteDataSource.signOut());
      verifyNoMoreInteractions(remoteDataSource);
    });
  });

  group('Sign in with email and password', () {
    test('should return Right of user model when login successfully', () async {
      // arrange
      when(remoteDataSource.signIn(any)).thenAnswer((_) async => userModel);
      // act
      final result = await repository.signIn(signInParams);
      //assert
      expect(result, Right(userModel));
    });

    test(
        'should return Left of AuthenticationFailure when login credential is invalid',
        () async {
      // arrange
      when(remoteDataSource.signIn(any))
          .thenThrow(FirebaseAuthException(code: authErrorCode));
      // act
      final result = await repository.signIn(signInParams);
      //assert
      expect(result, Left(AuthenticationFailure(authErrorCode)));
    });

    test(
        'should return Left of Connection Failure when catch another exception',
        () async {
      // arrange
      when(remoteDataSource.signIn(any)).thenThrow(ConnectionException());
      // act
      final result = await repository.signIn(signInParams);
      //assert
      expect(result, Left(ConnectionFailure()));
    });
  });

  group('Sign up', () {
    test('should return Right when sign up successfully', () async {
      // arrange
      when(remoteDataSource.signUp(any)).thenAnswer((_) async => userModel);
      // act
      final result = await repository.signUp(signUpParams);
      //assert
      expect(result, Right(userModel));
    });

    test(
        'should return Left of Authentication failure when sign up unsuccessfully',
        () async {
      // arrange
      when(remoteDataSource.signUp(any))
          .thenThrow(FirebaseAuthException(code: authErrorCode));
      // act
      final result = await repository.signUp(signUpParams);
      //assert
      expect(result, Left(AuthenticationFailure(authErrorCode)));
    });

    test(
        'should return Left of Connection Failure when sign up catch another exception',
        () async {
      // arrange
      when(remoteDataSource.signUp(any)).thenThrow(ConnectionException());
      // act
      final result = await repository.signUp(signUpParams);
      //assert
      expect(result, Left(ConnectionFailure()));
    });
  });

  group('Sign out', () {
    test('should return Right if sign out successfully', () async {
      // arrange
      when(remoteDataSource.signOut()).thenAnswer((_) => null);
      // act
      final result = await repository.signOut();
      //assert
      expect(result, isA<Right>());
    });

    test('should return Left when sign out is unsuccessfully', () async {
      // arrange
      when(remoteDataSource.signOut()).thenThrow(ConnectionException());
      // act
      final result = await repository.signOut();
      //assert
      expect(result, Left(ConnectionFailure()));
    });
  });
}
