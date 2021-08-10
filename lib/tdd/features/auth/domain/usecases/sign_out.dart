import 'package:the/tdd/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:the/tdd/core/usecases/usecase.dart';
import 'package:the/tdd/features/auth/domain/repositories/auth_repository.dart';

class SignOut extends BaseUseCase<void, NoParams> {
  final AuthRepository _repository;

  SignOut(this._repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) => _repository.signOut();
}
