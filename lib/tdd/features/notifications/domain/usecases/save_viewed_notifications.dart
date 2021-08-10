import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:the/tdd/core/errors/failures.dart';
import 'package:the/tdd/core/usecases/usecase.dart';
import 'package:the/tdd/features/notifications/domain/repositories/notifications_repository.dart';

class SaveViewedNotification
    extends BaseUseCase<void, SaveViewedNotificationParams> {
  final NotificationsRepository _repository;
  SaveViewedNotification(this._repository);

  @override
  Future<Either<Failure, void>> call(SaveViewedNotificationParams params) =>
      _repository.saveViewedNotification(params.notificationId);
}

class SaveViewedNotificationParams extends Equatable {
  final String notificationId;
  SaveViewedNotificationParams(this.notificationId);

  @override
  List<Object> get props => [notificationId];
}
