import 'package:dartz/dartz.dart';
import 'package:trackit/core/errors/failures.dart';
import 'package:trackit/domain/entities/transaction.dart';
import 'package:trackit/domain/repositories/transaction_repository.dart';

class UpdateTransactionUsecase {
  final TransactionRepository repository;

  UpdateTransactionUsecase({required this.repository});

  Future<Either<Failure, Unit>> call(Transaction transaction) async {
    return await repository.updateTransaction(transaction);
  }
}
