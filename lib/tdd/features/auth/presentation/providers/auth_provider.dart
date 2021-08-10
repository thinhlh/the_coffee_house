import 'package:flutter/material.dart';
import 'package:the/tdd/common/domain/entities/custom_user.dart';
import 'package:the/tdd/core/base/base_provider.dart';
import 'package:the/tdd/core/base/base_provider.dart';
import 'package:the/tdd/core/errors/exceptions.dart';
import 'package:the/tdd/core/errors/failures.dart';
import 'package:the/tdd/core/usecases/usecase.dart';
import 'package:the/tdd/features/auth/domain/usecases/sign_in_with_email_and_password.dart';
import 'package:the/tdd/features/auth/domain/usecases/sign_out.dart';
import 'package:the/tdd/features/auth/domain/usecases/sign_up.dart';
import 'package:the/tdd/features/auth/presentation/pages/sign_in_page.dart';
import 'package:the/tdd/features/auth/presentation/pages/signup_page.dart';
import 'package:the/tdd/features/user/domain/usecases/fetch_user.dart';

class AuthProvider extends BaseProvider {
  final SignInWithEmailAndPassword _signInWithEmailAndPassword;
  final SignUp _signUp;
  final SignOut _signOut;
  final FetchUser _fetchUser;

  String _message = 'Log in';
  CustomUser _user;

  CustomUser get user => _user;
  String get message => _message;

  AuthProvider(
    this._signInWithEmailAndPassword,
    this._signUp,
    this._signOut,
    this._fetchUser,
  );

  Future<void> fetchUser() async {
    final result = await _fetchUser(NoParams());

    result.fold((failure) {
      _message = (failure as ConnectionFailure).message;
      throw ConnectionException();
    }, (user) {
      _user = user;
    });
    notifyListeners();
  }

  void toggleFavoriteProduct(String productId) {
    final index = user.favoriteProducts.indexOf(productId);
    if (index < 0) {
      user.favoriteProducts.add(productId);
    } else {
      user.favoriteProducts.remove(productId);
    }
    notifyListeners();
  }

  Future<void> signIn(SignInParams signInParams) async {
    showLoading();
    final result = await _signInWithEmailAndPassword(signInParams);

    result.fold((failure) {
      _message = failure is AuthenticationFailure
          ? failure.message
          : 'Connection failed';
    }, (user) {
      _message = 'Signed In';
      _user = user;
    });
    dispatchLoading();
  }

  Future<void> signUp(SignUpParams signUpParams) async {
    showLoading();

    final result = await _signUp(signUpParams);
    result.fold(
        (failure) => _message = (failure is AuthenticationFailure)
            ? failure.message
            : 'Connection failed',
        (user) => _user = user);

    dispatchLoading();
  }

  Future<void> signOut() async {
    showLoading();
    final result = await _signOut(NoParams());

    result.fold(
      (failure) => _message = (failure as ConnectionFailure).message,
      (right) {
        _message = 'Sign out successfully';
        _user = null;
      },
    );
    dispatchLoading();
  }

  Future<void> navigateToSignIn(BuildContext context) =>
      Navigator.of(context).pushReplacementNamed(SignInPage.routeName);

  Future<void> navigateToSignUp(BuildContext context) =>
      Navigator.of(context).pushReplacementNamed(SignUpPage.routeName);
}
