import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:the/tdd/core/errors/failures.dart';
import 'package:the/tdd/core/usecases/usecase.dart';
import 'package:the/tdd/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:the/tdd/features/notifications/domain/usecases/get_viewed_notifications.dart';

class MockNotificationsRepository extends Mock
    implements NotificationsRepository {}

void main() {
  MockNotificationsRepository repository;
  GetViewedNotifications usecase;

  setUp(() {
    repository = MockNotificationsRepository();
    usecase = GetViewedNotifications(repository);
  });

  final viewedNotifications = ['abc', 'def'];

  test('should forward the call to repository', () async {
    // arrange

    // act
    usecase(NoParams());
    //assert
    verify(repository.getViewedNotifications());
    verifyNoMoreInteractions(repository);
  });

  test(
      'should return Right of viewed notifications when repository return Right of viewed notifications',
      () async {
    // arrange
    when(repository.getViewedNotifications())
        .thenAnswer((_) async => Right(viewedNotifications));
    // act
    final result = await usecase(NoParams());
    //assert
    expect(result, Right(viewedNotifications));
  });

  test(
      'should return Left of local data source failure when repository return Left of local data source failure',
      () async {
    // arrange
    when(repository.getViewedNotifications())
        .thenAnswer((_) async => Left(LocalDataSourceFailure()));
    // act
    final result = await usecase(NoParams());
    //assert
    expect(result, Left(LocalDataSourceFailure()));
  });
}
