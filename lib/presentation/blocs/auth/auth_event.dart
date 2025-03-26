part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class CheckAuthenticatedEvent extends AuthEvent {}

class SignUpEvent extends AuthEvent {
  final String email;
  final String name;
  final String password;

  const SignUpEvent({
    required this.email,
    required this.name,
    required this.password,
  });

  @override
  List<Object?> get props => [email, name, password];
}

class SignInEvent extends AuthEvent {
  final String email;
  final String password;

  const SignInEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class ResetPasswordEvent extends AuthEvent {
  final String email;

  const ResetPasswordEvent({
    required this.email,
  });

  @override
  List<Object?> get props => [email];
}

class LogOutEvent extends AuthEvent {}
