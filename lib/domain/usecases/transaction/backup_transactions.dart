import 'package:dartz/dartz.dart';
import 'package:trackit/core/errors/failures.dart';
import 'package:trackit/domain/repositories/transaction_repository.dart';

class BackupTransactionsUsecase {
  final TransactionRepository repository;

  BackupTransactionsUsecase({required this.repository});

  Future<Either<Failure, Unit>> call() async {
    return await repository.backupTransactions();
  }
}
