class AuthenticateException implements Exception {
  String message;
  AuthMessages code;
  AuthenticateException({this.message, this.code});
}

enum AuthMessages {
  UserDismissedGoogleSignIn,
  UserDismissedFacebookSignIn,
}
