import 'package:flutter_test/flutter_test.dart';
import 'package:the/tdd/common/domain/entities/membership.dart';
import 'package:the/tdd/features/notifications/data/models/notification_model.dart';
import 'package:the/tdd/features/notifications/domain/entities/notification.dart';

void main() {
  final notificationModel = NotificationModel(
      id: 'id',
      title: 'title',
      description: 'description',
      imageUrl: 'imageUrl',
      dateTime: DateTime(2021),
      targetCustomers: [Membership.Bronze]);

  final Map<String, dynamic> mappedNotification = {
    'id': 'id',
    'title': 'title',
    'description': 'description',
    'imageUrl': 'imageUrl',
    'dateTime': DateTime(2021),
    'targetCustomer': ['Bronze'],
  };

  test('should notification model is a subclass of notification', () async {
    // arrange

    // act

    //assert
    expect(notificationModel, isA<Notification>());
  });

  test('should to map return valid map from notification model', () async {
    // arrange

    // act
    final result = notificationModel.toMap();
    //assert
    expect(result, {...mappedNotification}..remove('id'));
  });

  test('should from map return valid notification model', () async {
    // arrange

    // act
    final result = NotificationModel.fromMap(mappedNotification);
    //assert
    expect(result, notificationModel);
  });
}
