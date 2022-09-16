import 'package:flutter/foundation.dart';

import '../models/notification.dart';
import '../services/notifications_api.dart';

class Notifications with ChangeNotifier {
  List<Notification> _notifications = [];

  Notifications.initialize();

  List<Notification> get notifications => [..._notifications];

  Notification getNotificationById(String id) {
    return _notifications.firstWhere((element) => element.id == id);
  }

  Future<void> addNotification(
    Notification notification,
    bool isLocalImage,
  ) async {
    try {
      return NotificationsAPI().addNotification(notification, isLocalImage);
    } catch (error) {
      //TODO handling error
      throw error;
    }
  }

  Future<void> updateNotification(
    Notification notification,
    bool isLocalImage,
  ) async {
    final index =
        _notifications.indexWhere((value) => value.id == notification.id);
    if (index < 0) return;
    try {
      return NotificationsAPI().updateNotification(notification, isLocalImage);
    } catch (error) {
      //TODO handling error
    }
  }

  Future<void> deleteNotification(String id) async {
    try {
      await NotificationsAPI().delete(id);
      notifyListeners();
    } catch (error) {
      //TODO handling error
    }
  }

  List<Notification> searchNotification(String title) {
    return _notifications
        .where(
          (product) =>
              product.title.trim().toLowerCase().contains(title.toLowerCase()),
        )
        .toList();
  }

  Notifications.fromList(this._notifications);
}
