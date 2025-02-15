import 'package:dartz/dartz.dart';
import 'package:trackit/core/errors/failures.dart';
import 'package:trackit/domain/repositories/account_repository.dart';

class DeleteAccountUsecase {
  final AccountRepository repository;

  DeleteAccountUsecase({required this.repository});

  Future<Either<Failure, Unit>> call(int id) async {
    return await repository.deleteAccount(id);
  }
}
