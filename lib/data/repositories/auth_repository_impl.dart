import 'package:trackit/data/datasources/auth_remote_datasource.dart';
import 'package:trackit/domain/entities/user.dart';
import 'package:trackit/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;

  AuthRepositoryImpl({required this.remoteDatasource});

  @override
  Future<User> createUser(String email, String name, String password) async {
    return await remoteDatasource.signUp(email, name, password);
  }

  @override
  Future<User> logIn(String email, String password) async {
    return await remoteDatasource.signIn(email, password);
  }

  @override
  Future<void> logOut() async {
    return await remoteDatasource.signOut();
  }

  @override
  Future<void> resetPassword(String email) async {
    return await remoteDatasource.resetPassword(email);
  }
}
