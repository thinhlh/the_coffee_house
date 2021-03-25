import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_coffee_house/models/user.dart';

class FireStoreApi {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUser(User user) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    users.add({
      'uid': user.uid,
      'email': user.email,
      'birthday': user.birthday,
    }).then((value) => print(value));
  }
}
