import 'package:the/tdd/core/errors/exceptions.dart';
import 'package:the/tdd/features/notifications/data/datasources/notifications_local_data_source.dart';
import 'package:the/tdd/features/notifications/data/datasources/notifications_remote_data_source.dart';
import 'package:the/tdd/features/notifications/domain/entities/notification.dart';
import 'package:the/tdd/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:the/tdd/features/notifications/domain/repositories/notifications_repository.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsRemoteDataSource _remoteDataSource;
  final NotificationsLocalDataSource _localDataSource;

  NotificationsRepositoryImpl(
    this._localDataSource,
    this._remoteDataSource,
  );

  @override
  Future<Either<Failure, List<Notification>>> fetchNotifications() async {
    try {
      final result = await _remoteDataSource.fetchNotifications();
      return Right(result);
    } on ConnectionException {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, List<String>>> getViewedNotifications() async {
    try {
      final result = _localDataSource.getViewedNotifications();
      return Right(result);
    } on LocalDataSourceException {
      return Left(LocalDataSourceFailure());
    }
  }

  @override
  Future<Either<Failure, void>> saveViewedNotification(
    String notificationId,
  ) async {
    try {
      await _localDataSource.saveViewedNotification(notificationId);
      return Right(null);
    } on LocalDataSourceException {
      return Left(LocalDataSourceFailure());
    }
  }
}
