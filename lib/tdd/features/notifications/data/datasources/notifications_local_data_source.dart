import 'package:the/tdd/core/errors/exceptions.dart';
import 'package:the/tdd/core/shared_preferences/app_shared_preferences.dart';

abstract class NotificationsLocalDataSource {
  List<String> getViewedNotifications();

  Future<void> saveViewedNotification(String notificationId);
}

class NotificationsLocalDataSourceImpl implements NotificationsLocalDataSource {
  @override
  List<String> getViewedNotifications() {
    try {
      return AppSharedPreferences.getViewedNotifications() ?? [];
    } on Exception {
      throw LocalDataSourceException();
    }
  }

  @override
  Future<void> saveViewedNotification(String notificationId) {
    try {
      return AppSharedPreferences.addViewedNotification(notificationId);
    } on Exception {
      throw LocalDataSourceException();
    }
  }
}
