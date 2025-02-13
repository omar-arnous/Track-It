import 'package:trackit/domain/entities/user.dart';
import 'package:trackit/domain/repositories/auth_repository.dart';

class LoginUsecase {
  final AuthRepository repository;

  LoginUsecase({required this.repository});

  Future<User> call(String email, String password) async {
    return await repository.logIn(email, password);
  }
}
