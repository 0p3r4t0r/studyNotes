import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  // If the subclasses have some properties, pass them to this constructor
  // so that Equatable can perform value comparison.
  Failure([List properties = const <dynamic>[]]) : super(properties);
}

// General failures
class ServerFailure extends Failure {}

class CacheFailure extends Failure {}
