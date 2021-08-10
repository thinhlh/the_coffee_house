import 'package:dartz/dartz.dart' show Either;
import 'package:the/tdd/common/domain/entities/custom_user.dart';
import 'package:the/tdd/core/errors/failures.dart';
import 'package:the/tdd/features/auth/domain/usecases/sign_in_with_email_and_password.dart';
import 'package:the/tdd/features/auth/domain/usecases/sign_up.dart';

//This is where the usecase call
abstract class AuthRepository {
  Future<Either<Failure, CustomUser>> signIn(SignInParams signInParams);
  Future<Either<Failure, CustomUser>> signUp(SignUpParams signUpParams);
  Future<Either<Failure, void>> signOut();
}
