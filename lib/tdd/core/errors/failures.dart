import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {}

class ConnectionFailure extends Failure {
  final String message;

  ConnectionFailure({this.message});

  @override
  List<Object> get props => [this.message];
}

class AuthenticationFailure extends Failure {
  final String _code;

  AuthenticationFailure(this._code);

  String get code => this._code;

  String get message {
    String _message = 'Unable to identify error';
    if (this._code == null) return _message;
    switch (this._code) {
      case 'user-not-found':
        return 'No user found for given email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'user-disabled':
        return 'This account is disabled, please contact the customer service';
      case 'email-already-in-use':
        return 'The email is already exists.';
      case 'weak-password':
        return 'The password is not strong enough';
    }
    return _message;
  }

  @override
  List<Object> get props => [];
}

class LocalDataSourceFailure extends Failure {
  final String message;

  LocalDataSourceFailure({this.message});

  @override
  List<Object> get props => [this.message];
}

class CacheNotFoundFailure extends Failure {
  @override
  List<Object> get props => [];
}
