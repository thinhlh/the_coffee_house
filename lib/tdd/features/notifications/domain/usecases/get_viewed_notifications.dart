import 'package:the/tdd/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:the/tdd/core/usecases/usecase.dart';
import 'package:the/tdd/features/notifications/domain/repositories/notifications_repository.dart';

class GetViewedNotifications extends BaseUseCase<List<String>, NoParams> {
  NotificationsRepository _repository;
  GetViewedNotifications(this._repository);

  @override
  Future<Either<Failure, List<String>>> call(NoParams params) =>
      _repository.getViewedNotifications();
}
