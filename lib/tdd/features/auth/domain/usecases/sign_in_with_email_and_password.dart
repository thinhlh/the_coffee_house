import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:the/tdd/common/domain/entities/custom_user.dart';
import 'package:the/tdd/core/errors/failures.dart';
import 'package:the/tdd/core/usecases/usecase.dart';
import 'package:the/tdd/features/auth/domain/repositories/auth_repository.dart';

class SignInWithEmailAndPassword extends BaseUseCase<CustomUser, SignInParams> {
  final AuthRepository _repository;

  SignInWithEmailAndPassword(this._repository);
  @override
  Future<Either<Failure, CustomUser>> call(SignInParams params) =>
      _repository.signIn(params);
}

class SignInParams extends Equatable {
  final String email;
  final String password;

  SignInParams({@required this.email, @required this.password});

  @override
  List<Object> get props => [email, password];
}
