import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the/models/custom_user.dart';
import 'package:the/services/users_api.dart';

class Users with ChangeNotifier {
  List<CustomUser> _users = [];

  List<CustomUser> get users {
    return [..._users];
  }

  Users.fromList(this._users);

  Future<void> fetchAndUpdateUsersInfo() async {
    return FirebaseFirestore.instance.collection('users').get().then(
          (collectionSnapshot) => (collectionSnapshot) => Users.fromList(
                collectionSnapshot.docs.map((documentSnapshot) {
                  Map<String, Object> json = documentSnapshot.data();
                  json['uid'] = documentSnapshot.id;
                  return CustomUser.fromJson(json);
                }).toList(),
              ),
        );
  }

  CustomUser getUserById(String id) {
    return [..._users]
        .firstWhere((element) => element.uid == id, orElse: () => null);
  }

  Future<void> deleteUser(String id) async {
    return UsersAPI().delete(id);
  }

  List<CustomUser> searchUser(String query) {
    return [..._users].where((user) {
      String queryLowerCase = query.trim().toLowerCase();
      return user.email.trim().toLowerCase().contains(queryLowerCase) ||
          user.uid.trim().toLowerCase().contains(queryLowerCase) ||
          user.email.trim().toLowerCase().contains(queryLowerCase);
    }).toList();
  }
}
