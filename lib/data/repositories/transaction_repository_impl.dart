import 'package:dartz/dartz.dart';
import 'package:trackit/core/errors/exceptions.dart';
import 'package:trackit/core/errors/failures.dart';
import 'package:trackit/data/datasources/transaction/transaction_local_datasource.dart';
import 'package:trackit/data/models/transaction_model.dart';
import 'package:trackit/domain/entities/transaction.dart';
import 'package:trackit/domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalDatasource localDatasource;

  TransactionRepositoryImpl({required this.localDatasource});

  @override
  Future<Either<Failure, List<Transaction>>> getTransactionsByAccountId(
      int id) async {
    try {
      final transactions = await localDatasource.getTransactionByAccountId(id);
      return Right(transactions);
    } on EmptyDatabaseException {
      return Left(EmptyDatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> addTransaction(Transaction transaction) async {
    try {
      final data = TransactionModel(
        transactionType: transaction.transactionType,
        amount: transaction.amount,
        currency: transaction.currency,
        exchangeRate: transaction.exchangeRate,
        convertedAmount: transaction.convertedAmount,
        note: transaction.note,
        date: transaction.date,
        time: transaction.time,
        accountId: transaction.accountId,
        targetAccountId: null,
        categoryId: transaction.categoryId,
      );
      await localDatasource.addTransaction(data);
      return const Right(unit);
    } on DatabaseAddException {
      return Left(DatabaseAddFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateTransaction(
      Transaction transaction) async {
    try {
      final data = TransactionModel(
        id: transaction.id,
        transactionType: transaction.transactionType,
        amount: transaction.amount,
        currency: transaction.currency,
        exchangeRate: transaction.exchangeRate,
        convertedAmount: transaction.convertedAmount,
        note: transaction.note,
        date: transaction.date,
        time: transaction.time,
        accountId: transaction.accountId,
        targetAccountId: transaction.targetAccountId,
        categoryId: transaction.categoryId,
      );
      await localDatasource.updateTransaction(data);
      return const Right(unit);
    } on DatabaseEditException {
      return Left(DatabaseEditFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteTransaction(int id) async {
    try {
      await localDatasource.deleteTransaction(id);
      return const Right(unit);
    } on DatabaseDeleteException {
      return Left(DatabaseDeleteFailure());
    }
  }
}
