import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static SharedPreferences sharedPreferences;

  static const String VIEWED_NOTIFICATIONS = 'viewed_notifications';
  static const String DELIVERY_LOCATION =
      'delivery_location'; //The address where customer prefer to be deliveried
  static const String TAKE_AWAY_LOCATION =
      'take_away_location'; // The id of store where customer prefer to take away

  Future<void> init() async {
    if (sharedPreferences == null)
      sharedPreferences = await SharedPreferences.getInstance();
  }

  List<String> get viewedNotifications {
    final uid = FirebaseAuth.instance.currentUser.uid;
    final userSettings = sharedPreferences.getString(uid);
    if (userSettings == null) return [];
    final list = ((json.decode(userSettings)
                as Map<String, dynamic>)[VIEWED_NOTIFICATIONS] as List<dynamic>)
            .cast<String>()
            .toList() ??
        [];
    return list;
  }

  int numberOfViewedNotification(List<String> notifications) {
    int result = 0;
    List<String> _viewedNotifications = viewedNotifications;
    _viewedNotifications.forEach((element) {
      if (notifications.contains(element)) {
        result++;
      }
    });
    return result;
  }

  Future<void> addViewedNotifications(String notificationId) async {
    final _viewedNotifications = this.viewedNotifications;

    if (_viewedNotifications.contains(notificationId))
      return Future.value(true);

    _viewedNotifications.add(notificationId);

    final encodedJson = json.encode({
      VIEWED_NOTIFICATIONS: _viewedNotifications,
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

  String get deliveryLocation {
    return sharedPreferences.containsKey(DELIVERY_LOCATION)
        ? sharedPreferences.getString(DELIVERY_LOCATION)
        : '';
  }

  String get takeAwayLocation {
    return sharedPreferences.containsKey(TAKE_AWAY_LOCATION)
        ? sharedPreferences.getString(TAKE_AWAY_LOCATION)
        : '';
  }

  Future<bool> setDeliveryLocation(String location) {
    return sharedPreferences.setString(DELIVERY_LOCATION, location);
  }

  Future<bool> setTakeAwayLocation(String location) {
    return sharedPreferences.setString(TAKE_AWAY_LOCATION, location);
  }
}
