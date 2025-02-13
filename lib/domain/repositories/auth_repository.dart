import 'package:trackit/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> createUser(String email, String name, String password);
  Future<User> logIn(String email, String password);
  Future<void> logOut();
  Future<void> resetPassword(String email);
}
