import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the/tdd/core/shared_preferences/shared_preferences_keys.dart';
import 'package:the/tdd/features/address/data/models/delivery_detail_model.dart';

class AppSharedPreferences {
  static SharedPreferences sharedPreferences;

  static Future<void> init() async {
    if (sharedPreferences == null) {
      sharedPreferences = await SharedPreferences.getInstance();
    }
  }

  static Future<bool> saveNewDeliveryDetail(
    DeliveryDetailModel deliveryDetail,
  ) async {
    return sharedPreferences.setStringList(
      SAVED_DELIVERY_DETAIL,
      sharedPreferences.getStringList(SAVED_DELIVERY_DETAIL) ?? []
        ..add(json.encode(deliveryDetail.toMap())),
    );
  }

  static List<String> getViewedNotifications() {
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

  static Future<bool> addViewedNotification(String notificationId) async {
    final _viewedNotifications = getViewedNotifications();

    if (_viewedNotifications.contains(notificationId)) return null;

    _viewedNotifications.add(notificationId);

    final encodedJson = json.encode({
      VIEWED_NOTIFICATIONS: _viewedNotifications,
    });
    return await sharedPreferences.setString(
      FirebaseAuth.instance.currentUser.uid,
      encodedJson,
    );
  }

  static String getTakeAwayLocation() =>
      sharedPreferences.containsKey(TAKE_AWAY_LOCATION)
          ? sharedPreferences.getString(TAKE_AWAY_LOCATION)
          : '';

  static Map<String, dynamic> getLatestDeliveryDetail() =>
      sharedPreferences.containsKey(LATEST_DELIVERY_DETAIL)
          ? json.decode(sharedPreferences.getString(LATEST_DELIVERY_DETAIL))
              as Map<String, Object>
          : null;

  static List<Map<String, dynamic>> getSavedDeliveryDetailList() =>
      (sharedPreferences.getStringList(SAVED_DELIVERY_DETAIL) ?? [])
          .map((value) => json.decode(value) as Map<String, dynamic>)
          .toList();
}
