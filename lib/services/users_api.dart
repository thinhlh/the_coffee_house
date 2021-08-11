import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:the/models/custom_user.dart';
import 'package:the/providers/users.dart';
import 'package:the/services/fire_store.dart';
import 'package:http/http.dart' as http;
import 'package:the/utils/const.dart';
import 'package:the/utils/exceptions/http_exception.dart';

class UsersAPI implements BaseAPI {
  @override
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<void> add(object) {
    // TODO: implement delete
  }

  @override
  Future<void> delete(String id) async {
    final response = await http.delete(
      Uri.parse(SERVER_ENDPOINT + '/delete-user/$id'),
      headers: {
        'Authorization': 'the-coffee-house',
      },
    );
    if (response.statusCode < 300 || response.statusCode >= 200) {
      return response.body;
    } else {
      throw HttpException('Cannot delete user');
    }
  }

  @override
  // TODO: implement stream
  Stream<Users> get stream => firestore.collection('users').snapshots().map(
        (collectionSnapshot) => Users.fromList(
          collectionSnapshot.docs.map((documentSnapshot) {
            Map<String, Object> json = documentSnapshot.data();
            json['uid'] = documentSnapshot.id;
            return CustomUser.fromJson(json);
          }).toList(),
        ),
      );

  @override
  Future<void> update(newObject) {
    // TODO: implement update
  }

  Future<Map<String, Object>> getUserInfo(String uid) async {
    final result = await http
        .get(Uri.parse(SERVER_ENDPOINT + '/user-info/$uid'), headers: {
      'Authorization': 'the-coffee-house',
      'Content-Type': 'application/json'
    });
    return json.decode(result.body);
  }

  Future<void> toggleAccountRole(String uid, bool role) {
    return firestore.collection('users').doc(uid).update({'admin': role});
  }
}
