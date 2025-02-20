import 'package:dartz/dartz.dart';
import 'package:trackit/core/errors/failures.dart';
import 'package:trackit/domain/entities/transaction.dart';

abstract class TransactionRepository {
  Future<Either<Failure, List<Transaction>>> getTransactionsByAccountId(int id);
  Future<Either<Failure, Unit>> addTransaction(Transaction transaction);
  Future<Either<Failure, Unit>> updateTransaction(Transaction transaction);
  Future<Either<Failure, Unit>> deleteTransaction(int id);
}
