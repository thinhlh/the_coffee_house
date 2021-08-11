import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:the/models/store.dart';
import 'package:the/providers/stores.dart';
import 'package:the/services/fire_store.dart';

class StoresAPI extends BaseAPI {
  FirebaseStorage storage = FirebaseStorage.instance;

  @override
  Future<Store> add(store) async {
    final response = await super.firestore.collection('stores').add({
      'address': store.address,
      'coordinate': store.location,
      'imageUrls': store.imageUrls,
      'name': store.name,
    });
    return Store(
      id: response.id,
      name: store.name,
      address: store.address,
      location: store.location,
      imageUrl: store.imageUrl,
    );
  }

  Future<void> addStore(Store store, bool isNeededUploadToStorage) async {
    // if true => only add image Url
    if (isNeededUploadToStorage) {
      File file = File(store.imageUrl);
      String id = firestore.collection('stores').doc().id;
      return storage.ref('images/stores/$id').putFile(file).then((task) async {
        store.id = id;
        store.imageUrl = await task.ref.getDownloadURL();
        return super.firestore.collection('stores').doc(id).set(store.toJson());
      });
    } else {
      return super.firestore.collection('stores').add(store.toJson());
    }
  }

  Future<void> updateStore(
    Store store,
    bool isNeededUploadToStorage,
  ) {
    if (isNeededUploadToStorage) {
      File file = File(store.imageUrl);
      return storage
          .ref('images/stores/${store.id}')
          .putFile(file)
          .then((task) async {
        store.imageUrl = await task.ref.getDownloadURL();
        return super
            .firestore
            .collection('stores')
            .doc(store.id)
            .update(store.toJson());
      });
    } else {
      return super
          .firestore
          .collection('stores')
          .doc(store.id)
          .update(store.toJson());
    }
  }

  @override
  Future<void> delete(String id) async {
    await super.firestore.collection('stores').doc(id).delete();
  }

  @override
  Stream<Stores> get stream =>
      super.firestore.collection('stores').snapshots().map((querySnapshot) =>
          Stores.fromList(querySnapshot.docs.map((documentSnapshot) {
            Map<String, dynamic> json = documentSnapshot.data();
            json['id'] = documentSnapshot.id;
            return Store.fromJson(json);
          }).toList()));

  @override
  Future<void> update(newStore) async {
    await super.firestore.collection('stores').doc(newStore.id).update({
      'address': newStore.title,
      'coordinate': newStore.location,
      'imageUrls': newStore.imageUrls,
    });
  }

  Future<void> deleteStore(String id) async {
    try {
      await storage.ref('images/stores/$id').delete();
    } catch (error) {
      if (error is FirebaseException) {
        //(error as FirebaseException).code=='object-not-found' // Then dont delete at storage
      } else {
        throw error;
      }
    } finally {
      super.firestore.collection('stores').doc(id).delete();
    }
  }
}
