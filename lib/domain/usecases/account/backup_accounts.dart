import 'package:dartz/dartz.dart';
import 'package:trackit/core/errors/failures.dart';
import 'package:trackit/domain/repositories/account_repository.dart';

class BackupAccountsUsecase {
  final AccountRepository repository;

  BackupAccountsUsecase({required this.repository});

  Future<Either<Failure, Unit>> call() async {
    return await repository.backupAccounts();
  }
}
