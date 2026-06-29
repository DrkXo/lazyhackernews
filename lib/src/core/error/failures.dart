abstract class Failure {
  final String message;
  final int? code;

  const Failure({required this.message, this.code});

  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.code});
}

class NetworkFailure extends Failure {
  const NetworkFailure({required super.message, super.code});
}

class DataParsingFailure extends Failure {
  const DataParsingFailure({required super.message, super.code});
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure({required super.message, super.code});
}
