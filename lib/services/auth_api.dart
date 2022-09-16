import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:the/utils/exceptions/authenticate_exception.dart';

import '../models/custom_user.dart';
import '../utils/exceptions/http_exception.dart';
import 'user_api.dart';

class AuthAPI {
  FirebaseAuth _auth = FirebaseAuth.instance;

  bool get isAuth => _auth.currentUser != null;

  Stream<User> get user => _auth.authStateChanges();

  Future<void> signin(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw HttpException(e.code);
      } else if (e.code == 'wrong-password') {
        throw HttpException(e.code);
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> signInWithGoogle() async {
    GoogleSignIn _customGoogleSignIn = GoogleSignIn(scopes: [
      'email',
      'https://www.googleapis.com/auth/user.birthday.read',
    ]);

    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await _customGoogleSignIn.signIn();

    if (googleUser == null) {
      throw AuthenticateException(
        code: AuthMessages.UserDismissedGoogleSignIn,
      );
    }
    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    // Once signed in, return the UserCredential
    try {
      final userCredential = await _auth.signInWithCredential(credential);
      return _addUser(
        CustomUser(
          uid: userCredential.user.uid,
          name: userCredential.user.displayName,
          email: userCredential.user.email,
          birthday: userCredential.additionalUserInfo.profile['birthday'] ??
              DateTime.now(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  Future<void> signInWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();
    if (result.status == LoginStatus.success) {
      // you are logged
      final AccessToken accessToken = result.accessToken;
      if (accessToken != null) {
        final facebookAuthCredential =
            FacebookAuthProvider.credential(accessToken.token);
        final userCredential =
            await _auth.signInWithCredential(facebookAuthCredential);

        return _addUser(CustomUser(
          uid: userCredential.user.uid,
          name: userCredential.user.displayName,
          email: userCredential.user.email,
          birthday: userCredential.additionalUserInfo.profile['birthday'] ??
              DateTime.now(),
        ));
      }
    }
    //From this beyond, the below code only run if user dismiss login
    throw AuthenticateException(code: AuthMessages.UserDismissedFacebookSignIn);
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(CustomUser user, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: password,
      );
      user.uid = userCredential.user.uid;
      await _addUser(user);
    } on FirebaseAuthException catch (e) {
      throw HttpException(e.code);
    } catch (error) {
      throw error;
    }
  }

  Future<void> _addUser(CustomUser user) => UserAPI().addUser(user);
}
