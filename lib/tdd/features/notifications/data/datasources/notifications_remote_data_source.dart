import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the/tdd/core/errors/exceptions.dart';
import 'package:the/tdd/features/notifications/data/models/notification_model.dart';

abstract class NotificationsRemoteDataSource {
  Future<List<NotificationModel>> fetchNotifications();
}

class NotificationsRemoteDataSourceImpl
    implements NotificationsRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<NotificationModel>> fetchNotifications() async {
    try {
      final result = await _firestore
          .collection('notifications')
          .get()
          .timeout(Duration(minutes: 1));
      return result.docs
          .map(
            (document) => NotificationModel.fromMap(
              document.data()
                ..addEntries(
                  [MapEntry('id', document.id)],
                ),
            ),
          )
          .toList();
    } on TimeoutException {
      throw ConnectionException();
    }
  }
}
