import 'package:dartz/dartz.dart';
import 'package:trackit/core/errors/exceptions.dart';
import 'package:trackit/core/errors/failures.dart';
import 'package:trackit/core/network/network_info.dart';
import 'package:trackit/data/datasources/transaction/transaction_local_datasource.dart';
import 'package:trackit/data/datasources/transaction/transaction_remote_datasource.dart';
import 'package:trackit/data/models/transaction_model.dart';
import 'package:trackit/domain/entities/transaction.dart';
import 'package:trackit/domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalDatasource localDatasource;
  final TransactionRemoteDatasource remoteDatasource;
  final NetworkInfo networkInfo;

  TransactionRepositoryImpl({
    required this.localDatasource,
    required this.remoteDatasource,
    required this.networkInfo,
  });

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
        paymentType: transaction.paymentType,
        currency: transaction.currency,
        exchangeRate: transaction.exchangeRate,
        convertedAmount: transaction.convertedAmount,
        note: transaction.note,
        date: transaction.date,
        time: transaction.time,
        account: transaction.account,
        targetAccount: transaction.targetAccount,
        category: transaction.category,
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
        paymentType: transaction.paymentType,
        currency: transaction.currency,
        exchangeRate: transaction.exchangeRate,
        convertedAmount: transaction.convertedAmount,
        note: transaction.note,
        date: transaction.date,
        time: transaction.time,
        account: transaction.account,
        targetAccount: transaction.targetAccount,
        category: transaction.category,
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

  @override
  Future<Either<Failure, Unit>> backupTransactions(
      List<Transaction> transactions) async {
    if (await networkInfo.isConnected) {
      final List<TransactionModel> transactionsData = [];
      try {
        for (var transaction in transactions) {
          final transactionData = TransactionModel(
            id: transaction.id,
            transactionType: transaction.transactionType,
            amount: transaction.amount,
            paymentType: transaction.paymentType,
            currency: transaction.currency,
            exchangeRate: transaction.exchangeRate,
            convertedAmount: transaction.convertedAmount,
            note: transaction.note,
            date: transaction.date,
            time: transaction.time,
            account: transaction.account,
            targetAccount: transaction.targetAccount,
            category: transaction.category,
          );

          transactionsData.add(transactionData);
        }
        await remoteDatasource.addTransactions(transactionsData);
        return const Right(unit);
      } on FirestoreAddException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> restoreTransactions() async {
    if (await networkInfo.isConnected) {
      try {
        final stream = remoteDatasource.getTransactions();
        final transactions = await convertStreamToFuture(stream);
        return Right(transactions);
      } catch (_) {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }

  Future<List<Transaction>> convertStreamToFuture(
      Stream<Iterable<TransactionModel>> stream) async {
    final allAccounts = await stream
        .map((iterable) => iterable
            .toList()) // Convert each Iterable<AccountModel> to List<AccountModel>
        .fold<List<Transaction>>(
            [],
            (previous, current) =>
                previous..addAll(current)); // Collect all lists into one
    return allAccounts;
  }
}
