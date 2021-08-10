import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:the/tdd/common/data/models/custom_user_model.dart';
import 'package:the/tdd/core/errors/exceptions.dart';

abstract class UserRemoteDataSource {
  Future<CustomUserModel> fetchUser();
  Future<void> toggleFavoriteProduct(List<String> productIds);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<CustomUserModel> fetchUser() async {
    try {
      final result = await _firestore
          .collection('users')
          .doc(_auth.currentUser.uid)
          .get()
          .timeout(
            Duration(seconds: 30),
            onTimeout: () => throw ConnectionException(
                message: 'Please check your internet connection'),
          );
      return CustomUserModel.fromMap(
        result.data()
          ..addEntries([
            MapEntry('uid', result.id),
          ]),
      );
    } catch (e) {
      throw ConnectionException();
    }
  }

  @override
  Future<void> toggleFavoriteProduct(List<String> productIds) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser.uid)
          .update({'favoriteProducts': productIds});
    } on Exception {
      throw ConnectionException();
    }
  }
}
