import 'package:dartz/dartz.dart';
import 'package:trackit/core/errors/failures.dart';
import 'package:trackit/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> createUser(
      String email, String name, String password);
  Future<Either<Failure, User>> logIn(String email, String password);
  Future<Unit> logOut();
  Future<Unit> resetPassword(String email);
}
