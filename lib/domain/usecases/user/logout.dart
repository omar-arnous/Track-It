import 'package:dartz/dartz.dart';
import 'package:trackit/domain/repositories/auth_repository.dart';

class LogoutUsecase {
  final AuthRepository repository;

  LogoutUsecase({required this.repository});

  Future<Unit> call() async {
    return await repository.logOut();
  }
}
