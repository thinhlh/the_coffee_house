import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:the/tdd/common/domain/entities/custom_user.dart';
import 'package:the/tdd/core/errors/failures.dart';
import 'package:the/tdd/core/usecases/usecase.dart';
import 'package:the/tdd/features/auth/domain/repositories/auth_repository.dart';

class SignUp extends BaseUseCase<void, SignUpParams> {
  final AuthRepository repository;

  SignUp(this.repository);

  @override
  Future<Either<Failure, CustomUser>> call(SignUpParams params) =>
      repository.signUp(params);
}

class SignUpParams extends Equatable {
  final String email;
  final String password;
  final String name;
  final DateTime birthday;

  SignUpParams({
    @required this.email,
    @required this.password,
    @required this.name,
    @required this.birthday,
  });

  @override
  List<Object> get props => [
        email,
        password,
        name,
        birthday,
      ];
}
