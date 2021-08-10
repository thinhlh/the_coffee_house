import 'package:the/tdd/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:the/tdd/core/usecases/usecase.dart';
import 'package:the/tdd/features/notifications/domain/entities/notification.dart';
import 'package:the/tdd/features/notifications/domain/repositories/notifications_repository.dart';

class FetchNotifications extends BaseUseCase<List<Notification>, NoParams> {
  final NotificationsRepository _repository;
  FetchNotifications(this._repository);

  @override
  Future<Either<Failure, List<Notification>>> call(NoParams params) =>
      _repository.fetchNotifications();
}
