class ConnectionException implements Exception {
  final String message;

  ConnectionException({this.message});
}

class AuthenticationException implements Exception {
  final String code;

  AuthenticationException(this.code);
}

class LocalDataSourceException implements Exception {
  final String message;

  LocalDataSourceException({this.message});
}

class CacheNotFoundException implements Exception {}
