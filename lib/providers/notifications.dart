import 'package:flutter/widgets.dart' as widget;
import 'package:the_coffee_house/models/notification.dart';
import 'package:the_coffee_house/services/firestore_notifications.dart';

class Notifications with widget.ChangeNotifier {
  List<Notification> _notifications = [];

  Notifications.initialize();

  List<Notification> get notifications => [..._notifications];

  Notification getNotificationById(String id) {
    return _notifications.firstWhere((element) => element.id == id);
  }

  Future<void> addNotification(Notification notification) async {
    try {
      await FireStoreNotifications().add(notification);
    } catch (error) {
      //TODO handling error
      throw error;
    }
  }

  Future<void> updateNotification(Notification notification) async {
    final index =
        _notifications.indexWhere((value) => value.id == notification.id);
    if (index < 0) return;
    try {
      await FireStoreNotifications().update(notification);
    } catch (error) {
      //TODO handling error
    }
  }

  Future<void> deleteNotification(String id) async {
    try {
      await FireStoreNotifications().delete(id);
      notifyListeners();
    } catch (error) {
      //TODO handling error
    }
  }

  Notifications.fromList(this._notifications);
}
