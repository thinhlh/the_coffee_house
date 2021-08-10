import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:the/tdd/common/domain/entities/membership.dart';
import 'package:the/tdd/core/errors/failures.dart';
import 'package:the/tdd/core/usecases/usecase.dart';
import 'package:the/tdd/features/notifications/domain/entities/notification.dart';
import 'package:the/tdd/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:the/tdd/features/notifications/domain/usecases/fetch_notifications.dart';

class MockNotificationsRepository extends Mock
    implements NotificationsRepository {}

void main() {
  MockNotificationsRepository repository;
  FetchNotifications usecase;

  final List<Notification> notifications = [
    Notification(
      id: 'id',
      title: 'title',
      description: 'description',
      imageUrl: 'imageUrl',
      dateTime: DateTime.now(),
      targetCustomers: [Membership.Bronze],
    )
  ];

  setUp(() {
    repository = MockNotificationsRepository();
    usecase = FetchNotifications(repository);
  });

  test('should forward the call to repository', () async {
    // arrange

    // act
    usecase(NoParams());
    //assert
    verify(repository.fetchNotifications());
    verifyNoMoreInteractions(repository);
  });

  test(
      'should return Right of notifications when repository return Right of notifications',
      () async {
    // arrange
    when(repository.fetchNotifications())
        .thenAnswer((_) async => Right(notifications));
    // act
    final result = await usecase(NoParams());
    //assert
    expect(result, Right(notifications));
  });

  test(
      'should return Left of connection failure when repository return Left of connection failure',
      () async {
    // arrange
    when(repository.fetchNotifications())
        .thenAnswer((_) async => Left(ConnectionFailure()));
    // act
    final result = await usecase(NoParams());
    //assert
    expect(result, Left(ConnectionFailure()));
  });
}
