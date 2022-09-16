import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:the/models/membership.dart';
import 'package:http/http.dart' as http;
import 'package:the/utils/const.dart';

import '../models/notification.dart';
import '../providers/notifications.dart';
import 'fire_store.dart';

class NotificationsAPI extends BaseAPI {
  FirebaseStorage storage = FirebaseStorage.instance;

  @override
  Future<void> add(notification) async {
    try {
      await super
          .firestore
          .collection('notifications')
          .add(notification.toJson());
    } catch (error) {
      //TODO handling error
      throw error;
    }
  }

  Future<void> addNotification(
    Notification notification,
    bool isNeededUploadToStorage,
  ) async {
    // if true => only add image Url
    if (isNeededUploadToStorage) {
      File file = File(notification.imageUrl);
      String id = firestore.collection('notifications').doc().id;
      await storage
          .ref('images/notifications/$id')
          .putFile(file)
          .then((task) async {
        notification.id = id;
        notification.imageUrl = await task.ref.getDownloadURL();
        return super
            .firestore
            .collection('notifications')
            .doc(id)
            .set(notification.toJson());
      });
    } else {
      await super
          .firestore
          .collection('notifications')
          .add(notification.toJson());
    }
    return await _callPushNotification(notification);
  }

  @override
  Future<void> update(notification) async {
    try {
      await super
          .firestore
          .collection('notifications')
          .doc(notification.id)
          .update((notification as Notification).toJson());
    } catch (error) {
      //TODO handling error
    }
  }

  Future<void> updateNotification(
      Notification notification, bool isNeededUploadToStorage) async {
    if (isNeededUploadToStorage) {
      File file = File(notification.imageUrl);
      await storage
          .ref('images/notifications/${notification.id}')
          .putFile(file)
          .then((task) async {
        notification.imageUrl = await task.ref.getDownloadURL();
        return super
            .firestore
            .collection('products')
            .doc(notification.id)
            .update(notification.toJson());
      });
    } else {
      await super
          .firestore
          .collection('notifications')
          .doc(notification.id)
          .update(notification.toJson());
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      await storage.ref('images/notifications/' + id).delete();
    } catch (error) {
      if (error is FirebaseException) {
        //(error as FirebaseException).code=='object-not-found' // Then dont delete at storage
      } else {
        throw error;
      }
    } finally {
      super.firestore.collection('notifications').doc(id).delete();
    }
  }

  @override
  Stream<Notifications> get stream =>
      super.firestore.collection('notifications').snapshots().map(
            (querySnapshot) => Notifications.fromList(
              querySnapshot.docs.map((queryDocumentSnapshot) {
                Map<String, dynamic> json = queryDocumentSnapshot.data();
                json['id'] = queryDocumentSnapshot.id;
                return Notification.fromJson(json);
              }).toList(),
            ),
          );

  Stream<Notifications> getStream(Membership membership) {
    return super
        .firestore
        .collection('notifications')
        .where('targetCustomer', arrayContains: membership.valueString())
        .snapshots()
        .map(
          (querySnapshot) => Notifications.fromList(
            querySnapshot.docs.map((queryDocumentSnapshot) {
              Map<String, dynamic> json = queryDocumentSnapshot.data();
              json['id'] = queryDocumentSnapshot.id;
              return Notification.fromJson(json);
            }).toList(),
          ),
        );
  }

  Future<void> _callPushNotification(Notification notification) {
    return http
        .post(
          Uri.parse(SERVER_ENDPOINT + '/push-notification'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'the-coffee-house',
          },
          body: json.encode({
            'body': notification.description,
            'title': notification.title,
          }),
          // encoding: Encoding.getByName("utf-8"),
        )
        .then((value) => print(value.body));
  }
}
