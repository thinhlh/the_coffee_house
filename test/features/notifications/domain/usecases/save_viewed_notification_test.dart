import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:the/tdd/core/errors/failures.dart';
import 'package:the/tdd/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:the/tdd/features/notifications/domain/usecases/save_viewed_notifications.dart';

class MockNotificationsRepository extends Mock
    implements NotificationsRepository {}

void main() {
  MockNotificationsRepository repository;
  SaveViewedNotification usecase;

  setUp(() {
    repository = MockNotificationsRepository();
    usecase = SaveViewedNotification(repository);
  });

  final String viewedNotificationId = '';

  test('should forward the call to repository', () async {
    // arrange

    // act
    await usecase(SaveViewedNotificationParams(viewedNotificationId));
    //assert
    verify(repository.saveViewedNotification(viewedNotificationId));
    verifyNoMoreInteractions(repository);
  });

  test('should return Right when repository return Right', () async {
    // arrange
    when(repository.saveViewedNotification(viewedNotificationId))
        .thenAnswer((_) async => Right(null));
    // act
    final result =
        await usecase(SaveViewedNotificationParams(viewedNotificationId));
    //assert
    expect(result.isRight(), isTrue);
  });

  test(
      'should return Left of local data source when repository return Left of local data source',
      () async {
    // arrange
    when(repository.saveViewedNotification(viewedNotificationId))
        .thenAnswer((_) async => Left(LocalDataSourceFailure()));
    // act
    final result =
        await usecase(SaveViewedNotificationParams(viewedNotificationId));
    //assert
    expect(result, Left(LocalDataSourceFailure()));
  });
}
