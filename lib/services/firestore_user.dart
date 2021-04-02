import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_coffee_house/models/custom_user.dart';
import 'package:the_coffee_house/providers/user_provider.dart';
import 'package:the_coffee_house/services/fire_store.dart';

class FireStoreUser extends FireStoreApi {
  Stream<UserProvider> getUser(String uid) => super
          .firestore
          .collection('users')
          .doc(uid)
          .snapshots()
          .map((documentSnapshot) {
        Map<String, dynamic> json = documentSnapshot.data();
        json['uid'] = documentSnapshot.id;
        return UserProvider.fromJson(json);
      });

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

  // Future<void> deleteFavoritedProduct(String productId) async {
  //   try {
  //     final favoritedProducts = _user.favoriteProducts
  //       ..removeWhere((element) => element == productId);

  //     await super
  //         .firestore
  //         .collection('users')
  //         .doc(_user.uid)
  //         .update({'favoriteProducts': favoritedProducts});
  //   } catch (error) {
  //     //TODO handling error
  //     throw error;
  //   }
  // }
}
