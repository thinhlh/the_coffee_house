import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/custom_user.dart';
import '../providers/user_provider.dart';

class FireStoreUser {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<UserProvider> get user => firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .snapshots()
          .map((documentSnapshot) {
        Map<String, dynamic> json = documentSnapshot.data();
        json['uid'] = documentSnapshot.id;
        return UserProvider.fromJson(json);
      });

  Future<void> addUser(CustomUser user) async {
    CollectionReference users = firestore.collection('users');

    //Create a document with id received from auth
    try {
      await users.doc(user.uid).set(user.toJson());
    } catch (error) {
      //TODO handling error
      throw error;
    }
  }

  Future<void> toggleFavoriteProduct(
      String userUid, List<String> favoriteProducts) async {
    try {
      await firestore
          .collection('users')
          .doc(userUid)
          .update({'favoriteProducts': favoriteProducts});
    } catch (error) {
      //TODO handling error
    }
  }

  Future<void> editUser(Map<String, dynamic> newData) async {
    try {
      await firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .update(newData);
    } catch (error) {
      //TODO handling error
      throw error;
    }
  }
}
