import 'package:dartz/dartz.dart';
import 'package:trackit/core/errors/failures.dart';
import 'package:trackit/domain/entities/transaction.dart';
import 'package:trackit/domain/repositories/transaction_repository.dart';

class RestoreTransactionsUsecase {
  final TransactionRepository repository;

  RestoreTransactionsUsecase({required this.repository});

  Future<Either<Failure, List<Transaction>>> call() async {
    return await repository.restoreTransactions();
  }
}
