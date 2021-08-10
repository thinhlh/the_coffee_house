import 'package:dartz/dartz.dart';
import 'package:the/tdd/common/domain/entities/custom_user.dart';
import 'package:the/tdd/core/errors/failures.dart';
import 'package:the/tdd/core/usecases/usecase.dart';
import 'package:the/tdd/features/user/domain/repositories/user_repository.dart';

class FetchUser extends BaseUseCase<CustomUser, NoParams> {
  final UserRepository _repository;
  FetchUser(this._repository);

  @override
  Future<Either<Failure, CustomUser>> call(NoParams params) {
    return _repository.fetchUserData();
  }
}
