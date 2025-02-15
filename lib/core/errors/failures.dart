import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {}

class EmptyCacheFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class OfflineDatabaseFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class EmptyDatabaseFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class UserNotFoundAuthFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class UserNotLoggedInAuthFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class WrongPasswordAuthFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class WeakPasswordAuthFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class EmailAlreadyInUseAuthFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class InvalidEmailAuthFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class GenericAuthFailure extends Failure {
  @override
  List<Object?> get props => [];
}
