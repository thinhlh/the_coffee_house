import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:the/tdd/core/errors/exceptions.dart';
import 'package:the/tdd/core/errors/failures.dart';
import 'package:the/tdd/features/notifications/data/datasources/notifications_local_data_source.dart';
import 'package:the/tdd/features/notifications/data/datasources/notifications_remote_data_source.dart';
import 'package:the/tdd/features/notifications/data/models/notification_model.dart';
import 'package:the/tdd/features/notifications/data/repositories/notifications_repository_impl.dart';

class MockNotificationsRemoteDataSource extends Mock
    implements NotificationsRemoteDataSource {}

class MockNotificationsLocalDataSource extends Mock
    implements NotificationsLocalDataSource {}

void main() {
  MockNotificationsRemoteDataSource remoteDataSource;
  MockNotificationsLocalDataSource localDataSource;

  NotificationsRepositoryImpl repository;

  setUp(() {
    remoteDataSource = MockNotificationsRemoteDataSource();
    localDataSource = MockNotificationsLocalDataSource();
    repository = NotificationsRepositoryImpl(
      localDataSource,
      remoteDataSource,
    );
  });

  group('notifications remote data source', () {
    final notifications = [
      NotificationModel(
        id: 'id',
        title: 'title',
        description: 'description',
        imageUrl: 'imageUrl',
        dateTime: DateTime.now(),
      ),
    ];

    test('should forward the call to notification remote data source',
        () async {
      // arrange

      // act
      repository.fetchNotifications();
      //assert
      verify(remoteDataSource.fetchNotifications());
      verifyNoMoreInteractions(remoteDataSource);
    });

    test(
        'should return Right of notifications when remote data source return notifications',
        () async {
      // arrange
      when(remoteDataSource.fetchNotifications())
          .thenAnswer((_) async => notifications);
      // act
      final result = await repository.fetchNotifications();
      //assert
      expect(result, Right(notifications));
    });

    test(
        'should return Left of connection failure when remote data source throw connection exception',
        () async {
      // arrange
      when(remoteDataSource.fetchNotifications())
          .thenThrow(ConnectionException());
      // act
      final result = await repository.fetchNotifications();
      //assert
      expect(result, Left(ConnectionFailure()));
    });
  });

  group('notifications local data source', () {
    group('get viewed notifications', () {
      final viewedNotifications = ['abc', 'def'];

      test('should forward the call to local data source', () async {
        // arrange

        // act
        repository.getViewedNotifications();
        //assert
        verify(localDataSource.getViewedNotifications());
        verifyNoMoreInteractions(localDataSource);
      });

      test(
          'should return Right of viewed notifications when local data source return viewed notifications',
          () async {
        // arrange
        when(localDataSource.getViewedNotifications())
            .thenReturn(viewedNotifications);
        // act
        final result = await repository.getViewedNotifications();
        //assert
        expect(result, Right(viewedNotifications));
      });

      test(
          'should return Left of LocalDataSource failure when local data source throw LocalDataSource exception',
          () async {
        // arrange
        when(localDataSource.getViewedNotifications())
            .thenThrow(LocalDataSourceException());
        // act
        final result = await repository.getViewedNotifications();
        //assert
        expect(result, Left(LocalDataSourceFailure()));
      });
    });

    group('save viewed notification', () {
      final String viewedNotification = '';

      test('should forward the call to repository', () async {
        // arrange

        // act
        repository.saveViewedNotification(viewedNotification);
        //assert
        verify(localDataSource.saveViewedNotification(viewedNotification));
        verifyNoMoreInteractions(localDataSource);
      });

      test('should return Right when save viewed notification successfully',
          () async {
        // arrange
        when(localDataSource.saveViewedNotification(viewedNotification))
            .thenAnswer((_) async => null);
        // act
        final result =
            await repository.saveViewedNotification(viewedNotification);
        //assert
        expect(result, Right(null));
      });

      test(
          'should return Left when save viewed notification throw local data source exception',
          () async {
        // arrange
        when(localDataSource.saveViewedNotification(viewedNotification))
            .thenThrow(LocalDataSourceException());
        // act
        final result =
            await repository.saveViewedNotification(viewedNotification);
        //assert
        expect(result, Left(LocalDataSourceFailure()));
      });
    });
  });
}
