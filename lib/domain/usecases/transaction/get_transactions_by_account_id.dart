import 'package:dartz/dartz.dart';
import 'package:trackit/core/errors/failures.dart';
import 'package:trackit/domain/entities/transaction.dart';
import 'package:trackit/domain/repositories/transaction_repository.dart';

class GetTransactionsByAccountIdUsecase {
  final TransactionRepository repository;

  GetTransactionsByAccountIdUsecase({required this.repository});

  Future<Either<Failure, List<Transaction>>> call(int id) async {
    return await repository.getTransactionsByAccountId(id);
  }
}
