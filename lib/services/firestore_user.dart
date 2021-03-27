import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_coffee_house/models/custom_user.dart';
import 'package:the_coffee_house/services/fire_store.dart';

class FireStoreUser extends FireStoreApi {
  CustomUser _user;

  CustomUser get user => _user;

  CustomUser _extractToUser(DocumentSnapshot documentSnapshot) {
    final data = documentSnapshot.data();

    List<String> favoriteProducts = data['favoriteProducts'] == null
        ? []
        : (data['favoriteProducts'] as List<dynamic>).cast<String>();

    _user = CustomUser(
      uid: documentSnapshot.id,
      name: data['name'],
      email: data['email'],
      birthday: (data['birthday'] as Timestamp).toDate(),
      favoriteProducts: favoriteProducts,
    );
    return _user;
  }

  Future<CustomUser> getUser(String uid) async {
    if (_user != null) return _user;
    final documentSnapshot =
        await super.firestore.collection('users').doc(uid).get();
    return _extractToUser(documentSnapshot);
  }

  Future<void> addUser(CustomUser user) async {
    CollectionReference users = super.firestore.collection('users');

    //Create a document with id received from auth
    try {
      await users.doc(user.uid).set({
        'name': user.name,
        'email': user.email,
        'birthday': user.birthday,
        'favoriteProducts': user.favoriteProducts,
      });
    } catch (error) {
      throw error;
    }
  }

  Future<void> toggleFavoriteProduct(
      String userUid, List<String> favoriteProducts) async {
    return await super
        .firestore
        .collection('users')
        .doc(userUid)
        .update({'favoriteProducts': favoriteProducts});
  }

  //TODO handling error
}
