import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPref {
  static SharedPreferences sharedPreferences;

  static const String _viewedNotificationsKey = 'viewed_notifications';

  Future<void> init() async {
    if (sharedPreferences == null)
      sharedPreferences = await SharedPreferences.getInstance();
  }

  List<String> get viewedNotifications {
    final uid = FirebaseAuth.instance.currentUser.uid;
    final userSettings = sharedPreferences.getString(uid);
    print(uid);
    if (userSettings == null) return [];
    final list = ((json.decode(userSettings)
                    as Map<String, dynamic>)[_viewedNotificationsKey]
                as List<dynamic>)
            .cast<String>()
            .toList() ??
        [];
    print(list);
    return list;
  }

  Future<void> addViewedNotifications(String notificationId) async {
    final _viewedNotifications = this.viewedNotifications;

    if (_viewedNotifications.contains(notificationId))
      return Future.value(true);

    _viewedNotifications.add(notificationId);

    final encodedJson = json.encode({
      _viewedNotificationsKey: _viewedNotifications,
    });
    await sharedPreferences.setString(
      FirebaseAuth.instance.currentUser.uid,
      encodedJson,
    );
  }

  bool isViewedNotification(String notificationId) {
    return viewedNotifications.contains(notificationId);
  }

  void deleteAllViewedNotifications() async {
    bool response = await sharedPreferences.remove(
      FirebaseAuth.instance.currentUser.uid,
    );
    print(viewedNotifications);
    if (!response) {
      print('Failed to delete');
    }
  }
}
