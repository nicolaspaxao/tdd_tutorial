import 'package:equatable/equatable.dart';
import 'package:tdd_tutorial/core/errors/exceptions.dart';

abstract class Failure extends Equatable {
  final String message;
  final int statusCode;

  const Failure({required this.message, required this.statusCode});

  @override
  List<Object> get props => [message, statusCode];
}

class ApiFailure extends Failure {
  const ApiFailure({required super.message, required super.statusCode});

  factory ApiFailure.fromException(ApiException exception) {
    return ApiFailure(
        message: exception.message, statusCode: exception.statusCode);
  }
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message, required super.statusCode});
}
