import 'package:dartz/dartz.dart';
import 'package:trackit/core/errors/failures.dart';
import 'package:trackit/domain/entities/user.dart';
import 'package:trackit/domain/repositories/auth_repository.dart';

class CreateUserUsecase {
  final AuthRepository repository;

  CreateUserUsecase({required this.repository});

  Future<Either<Failure, User>> call(
      String email, String name, String password) async {
    return await repository.createUser(email, name, password);
  }
}
