class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException({required this.message, this.statusCode});

  @override
  String toString() => message;
}

class NetworkException implements Exception {
  final String message;

  const NetworkException({required this.message});

  @override
  String toString() => message;
}

class DataFormattingException implements Exception {
  final String message;
  final dynamic invalidData;

  const DataFormattingException({required this.message, this.invalidData});

  @override
  String toString() => message;
}
