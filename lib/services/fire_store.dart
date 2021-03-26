import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_coffee_house/models/user.dart';

class FireStoreApi {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUser(User user) async {
    CollectionReference users = _firestore.collection('users');

    //Create a document with id received from auth
    return users.doc(user.uid).set({
      'name': user.name,
      'email': user.email,
      'birthday': user.birthday,
    });
  }

  Future<void> toggleFavoriteProduct() async {}
}
