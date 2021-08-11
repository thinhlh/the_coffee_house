import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the/models/delivery_detail.dart';

class SharedPref {
  static SharedPreferences sharedPreferences;

  static const String VIEWED_NOTIFICATIONS = 'viewed_notifications';
  // static const String DELIVERY_LOCATION =
  //     'delivery_location'; //The address where customer prefer to be deliveried
  static const String TAKE_AWAY_LOCATION =
      'take_away_location'; // The id of store where customer prefer to take away
  static const String IS_PREFER_DELIVERIED = 'prefer_delivered';
  //To indicate whether customer choosed to be delivered or take away based on the last interaction with order card navigation
  static const String SAVED_DELIVERY_DETAIL = 'delivery_detail';

  static const String LATEST_DELIVERY_DETAIL = 'latest_delivery_detail';
  //Store the last delivery is used by user into local database

  static Future<void> init() async {
    if (sharedPreferences == null)
      sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<void> clearData() async {
    // deleteAllViewedNotifications();
    // deleteDeliveryAndTakeAwayLocation();
    sharedPreferences.clear();
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
    deleteDeliveryAndTakeAwayLocation();
    if (!response) {
      print('Failed to delete');
    }
  }

  String get takeAwayLocation {
    return sharedPreferences.containsKey(TAKE_AWAY_LOCATION)
        ? sharedPreferences.getString(TAKE_AWAY_LOCATION)
        : '';
  }

  Future<bool> setTakeAwayLocation(String location) {
    return sharedPreferences.setString(TAKE_AWAY_LOCATION, location);
  }

  bool get isPreferDelivered {
    return sharedPreferences.containsKey(IS_PREFER_DELIVERIED)
        ? sharedPreferences.getBool(IS_PREFER_DELIVERIED)
        : true;
  }

  Future<bool> setIsPreferDelivered(bool isPreferDelivered) {
    return sharedPreferences.setBool(IS_PREFER_DELIVERIED, isPreferDelivered);
  }

  void deleteDeliveryAndTakeAwayLocation() async {
    await sharedPreferences
        .remove(TAKE_AWAY_LOCATION)
        .then((value) => sharedPreferences.remove(IS_PREFER_DELIVERIED))
        .then((value) => sharedPreferences.remove(SAVED_DELIVERY_DETAIL))
        .then((value) => sharedPreferences.remove(LATEST_DELIVERY_DETAIL));
  }

  Future<bool> saveNewDeliveryDetail(DeliveryDetail deliveryDetail) {
    List<String> savedDeliveryDetail =
        sharedPreferences.getStringList(SAVED_DELIVERY_DETAIL) ?? []
          ..add(json.encode(deliveryDetail.toMap()));
    return sharedPreferences.setStringList(
      SAVED_DELIVERY_DETAIL,
      savedDeliveryDetail,
    );
  }

  List<DeliveryDetail> get savedDeliveryDetail {
    if (sharedPreferences.getStringList(SAVED_DELIVERY_DETAIL) == null) {
      return [];
    }
    return sharedPreferences
        .getStringList(SAVED_DELIVERY_DETAIL)
        .map(
          (e) => DeliveryDetail.fromMap(json.decode(e) as Map<String, Object>),
        )
        .toList();
  }

  DeliveryDetail get latestDeliveryDetail {
    return sharedPreferences.containsKey(LATEST_DELIVERY_DETAIL)
        ? DeliveryDetail.fromMap(
            json.decode(sharedPreferences.getString(LATEST_DELIVERY_DETAIL))
                as Map<String, Object>)
        : null;
  }

  Future<bool> setLatestDeliveryDetail(DeliveryDetail deliveryDetail) {
    return sharedPreferences.setString(
      LATEST_DELIVERY_DETAIL,
      json.encode(deliveryDetail.toMap()),
    );
  }

  Future<bool> deleteDeliveryDetail(DeliveryDetail deliveryDetail) {
    List<String> savedDeliveryDetail =
        sharedPreferences.getStringList(SAVED_DELIVERY_DETAIL);
    savedDeliveryDetail.removeWhere(
        (element) => json.encode(deliveryDetail.toMap()) == element);

    return sharedPreferences.setStringList(
      SAVED_DELIVERY_DETAIL,
      savedDeliveryDetail,
    );
  }
}
