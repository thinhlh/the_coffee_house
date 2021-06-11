import 'package:the_coffee_house/models/store.dart';
import 'package:the_coffee_house/providers/stores.dart';
import 'package:the_coffee_house/services/fire_store.dart';

class FireStoreStores extends FireStoreApi {
  @override
  Future<Store> add(store) async {
    final response = await super.firestore.collection('stores').add({
      'address': store.address,
      'coordinate': store.location,
      'imageUrls': store.imageUrls,
    });
    return Store(
      id: response.id,
      address: store.address,
      location: store.location,
      imageUrls: store.imageUrls,
    );
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
}
