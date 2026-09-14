/// Clean failure domain abstraction for repository layer.
abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure(super.message, {this.statusCode});
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network connection failed.']);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}
