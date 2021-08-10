import 'package:firebase_auth/firebase_auth.dart';
import 'package:the/tdd/common/domain/entities/custom_user.dart';
import 'package:the/tdd/core/errors/exceptions.dart';
import 'package:the/tdd/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:the/tdd/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:the/tdd/features/auth/domain/repositories/auth_repository.dart';
import 'package:the/tdd/features/auth/domain/usecases/sign_in_with_email_and_password.dart';
import 'package:the/tdd/features/auth/domain/usecases/sign_up.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, CustomUser>> signIn(SignInParams signInParams) async {
    try {
      final result = await _remoteDataSource.signIn(signInParams);
      return Right(result);
    } on FirebaseAuthException catch (authException) {
      return Left(AuthenticationFailure(authException.code));
    } on Exception catch (_) {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, CustomUser>> signUp(SignUpParams signUpParams) async {
    try {
      final result = await _remoteDataSource.signUp(signUpParams);
      return Right(result);
    } on FirebaseAuthException catch (authException) {
      return Left(AuthenticationFailure(authException.code));
    } on Exception catch (_) {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _remoteDataSource.signOut();
      return Right(null);
    } on ConnectionException {
      return Left(ConnectionFailure());
    }
  }
}
