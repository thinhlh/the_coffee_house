import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static SharedPreferences sharedPreferences;

  static const String _viewedNotificationsKey = 'viewed_notifications';

  Future<void> init() async {
    if (sharedPreferences == null)
      sharedPreferences = await SharedPreferences.getInstance();
  }

  List<String> get viewedNotifications {
    return sharedPreferences.getStringList(_viewedNotificationsKey) ?? [];
  }

  Future<bool> addViewedNotifications(String notificationId) async {
    final list = sharedPreferences.getStringList(_viewedNotificationsKey) ?? [];

    if (list.contains(notificationId)) return Future.value(true);
    return await sharedPreferences.setStringList(
        _viewedNotificationsKey, list..add(notificationId));
  }

  bool isViewedNotification(String notificationId) {
    final list = sharedPreferences.getStringList(_viewedNotificationsKey) ?? [];
    return list.contains(notificationId);
  }

  void deleteAllViewedNotifications() async {
    bool response = await sharedPreferences.remove(_viewedNotificationsKey);
    if (!response) {
      print('Failed to delete');
    }
  }
}
