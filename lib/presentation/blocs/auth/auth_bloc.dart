import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:trackit/core/errors/failures.dart';
import 'package:trackit/core/strings/failures.dart';
import 'package:trackit/domain/entities/user.dart';
import 'package:trackit/domain/usecases/user/create_user.dart';
import 'package:trackit/domain/usecases/user/get_authenticated_user.dart';
import 'package:trackit/domain/usecases/user/login.dart';
import 'package:trackit/domain/usecases/user/logout.dart';
import 'package:trackit/domain/usecases/user/reset_password.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final CreateUserUsecase createUser;
  final LoginUsecase login;
  final LogoutUsecase logout;
  final ResetPasswordUsecase resetPassword;
  final GetAuthenticatedUserUsecase getAuthenticatedUser;

  AuthBloc({
    required this.createUser,
    required this.login,
    required this.logout,
    required this.resetPassword,
    required this.getAuthenticatedUser,
  }) : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      if (event is CheckAuthenticatedEvent) {
        final res = await getAuthenticatedUser();
        emit(_mapResponseToState(res));
      }
      if (event is SignUpEvent) {
        emit(AuthLoading());
        try {
          final res = await createUser(
            event.email,
            event.name,
            event.password,
          );
          emit(_mapResponseToState(res));
        } catch (error) {
          emit(AuthError(message: error.toString()));
        }
      }
      if (event is SignInEvent) {
        emit(AuthLoading());
        try {
          final res = await login(event.email, event.password);
          emit(_mapResponseToState(res));
        } catch (error) {
          emit(AuthError(message: error.toString()));
        }
      }
      if (event is LogOutEvent) {
        emit(AuthLoading());

        await logout();
      }
      if (event is ResetPasswordEvent) {
        emit(AuthLoading());

        await resetPassword(event.email);
      }
    });
  }

  AuthState _mapResponseToState(Either<Failure, User> res) {
    return res.fold(
      (failure) => AuthError(message: _getMessage(failure)),
      (user) => Authenticated(user),
    );
  }

  String _getMessage(Failure failure) {
    switch (failure.runtimeType) {
      case EmptyCacheFailure:
        return kEmptyCacheFailureMessage;
      case UserNotFoundAuthFailure:
        return kUserNotFoundFailureMessage;
      case UserNotLoggedInAuthFailure:
        return kUserNotLoggedInFailureMessage;
      case WrongPasswordAuthFailure:
        return kWrongPasswordFailureMessage;
      case WeakPasswordAuthFailure:
        return kWeakPasswordFailureMessage;
      case EmailAlreadyInUseAuthFailure:
        return kEmailAlreadyInUserFailureMessage;
      case InvalidEmailAuthFailure:
        return kInvalidEmailFailureMessage;
      default:
        return kGenericFailureMessage;
    }
  }
}
