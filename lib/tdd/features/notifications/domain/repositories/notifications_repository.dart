import 'package:dartz/dartz.dart';
import 'package:the/tdd/core/errors/failures.dart';
import 'package:the/tdd/features/notifications/domain/entities/notification.dart';

abstract class NotificationsRepository {
  Future<Either<Failure, List<Notification>>> fetchNotifications();

  Future<Either<Failure, List<String>>> getViewedNotifications();

  Future<Either<Failure, void>> saveViewedNotification(String notificationId);
}
