import '../models/notification.dart';
import '../providers/notifications.dart';
import 'fire_store.dart';

class FireStoreNotifications extends FireStoreApi {
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

  @override
  Future<void> delete(String id) async {
    try {
      await super.firestore.collection('notifications').doc(id).delete();
    } catch (error) {
      //TODO handling error
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
}
