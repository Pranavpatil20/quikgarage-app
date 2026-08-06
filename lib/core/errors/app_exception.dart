class AppException implements Exception {
  const AppException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException([super.message = 'Network error. Check your connection.']);
}

class AuthException extends AppException {
  const AuthException([super.message = 'Authentication failed.']);
}

class ServerException extends AppException {
  const ServerException(super.message, {super.statusCode});
}
