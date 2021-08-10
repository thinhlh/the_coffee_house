import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:the/tdd/common/data/models/custom_user_model.dart';
import 'package:the/tdd/core/errors/exceptions.dart';
import 'package:the/tdd/features/auth/domain/usecases/sign_in_with_email_and_password.dart';
import 'package:the/tdd/features/auth/domain/usecases/sign_up.dart';

abstract class AuthRemoteDataSource {
  // return null => signed user in successfully
  // on error => inspect the exception to return appropriate failure [Connection Exception|Auth exception]
  Future<CustomUserModel> signIn(SignInParams signInParams);

  /// Return null => sign up successfully
  /// on error => inspect the exception to return appropriate failure [Connection Exception|Auth exception]
  Future<CustomUserModel> signUp(SignUpParams signUpParams);

  /// Return null => sign out successfully
  /// else on error => throw a Connection Exception
  Future<void> signOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<CustomUserModel> signIn(SignInParams signInParams) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: signInParams.email,
        password: signInParams.password,
      );
      final result = await _firestore
          .collection('users')
          .doc(userCredential.user.uid)
          .get();
      return CustomUserModel.fromMap(
        result.data()
          ..addEntries(
            [MapEntry('uid', userCredential.user.uid)],
          ),
      );
    } on FirebaseAuthException catch (authException) {
      throw authException;
    } on Exception catch (_) {
      throw ConnectionException();
    }
  }

  @override
  Future<CustomUserModel> signUp(SignUpParams signUpParams) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: signUpParams.email,
        password: signUpParams.password,
      );

      final userModel = CustomUserModel(
        userCredential.user.uid,
        signUpParams.name,
        signUpParams.password,
        signUpParams.birthday,
      );

      _firestore
          .collection('users')
          .doc(userCredential.user.uid)
          .set(userModel.toMap());

      return userModel;
    } on FirebaseAuthException catch (authException) {
      throw authException;
    } on Exception {
      throw ConnectionException();
    }
  }

  @override
  Future<void> signOut() async {
    return _auth.signOut().then(
          (value) => value,
          onError: (error) => throw ConnectionException(),
        );
  }
}
