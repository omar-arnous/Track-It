import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:trackit/domain/entities/user.dart';
import 'package:trackit/domain/usecases/user/create_user.dart';
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

  AuthBloc({
    required this.createUser,
    required this.login,
    required this.logout,
    required this.resetPassword,
  }) : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      if (event is SignUpEvent) {
        emit(AuthLoading());

        final user = await createUser(event.email, event.name, event.password);
        emit(Authenticated(user));
      }
      if (event is SignInEvent) {
        emit(AuthLoading());

        final user = await login(event.email, event.password);
        emit(Authenticated(user));
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
}
