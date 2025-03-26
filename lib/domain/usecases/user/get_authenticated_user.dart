import 'package:dartz/dartz.dart';
import 'package:trackit/core/errors/failures.dart';
import 'package:trackit/domain/entities/user.dart';
import 'package:trackit/domain/repositories/auth_repository.dart';

class GetAuthenticatedUserUsecase {
  final AuthRepository repository;

  GetAuthenticatedUserUsecase({required this.repository});

  Future<Either<Failure, User>> call() async {
    return await repository.getAuthenticatedUser();
  }
}
