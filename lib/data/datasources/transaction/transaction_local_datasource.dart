import 'package:dartz/dartz.dart';
import 'package:trackit/config/local_service.dart';
import 'package:trackit/core/constants/db_constants.dart';
import 'package:trackit/core/errors/exceptions.dart';
import 'package:trackit/data/models/transaction_model.dart';

abstract class TransactionLocalDatasource {
  Future<List<TransactionModel>> getTransactionByAccountId(int id);
  Future<Unit> addTransaction(TransactionModel transaction);
  Future<Unit> updateTransaction(TransactionModel transaction);
  Future<Unit> deleteTransaction(int id);
}

class TransactionLocalDatasourceImpl implements TransactionLocalDatasource {
  LocalService dbService;
  TransactionLocalDatasourceImpl({required this.dbService});

  @override
  Future<List<TransactionModel>> getTransactionByAccountId(int id) async {
    final db = await dbService.database;
    final data = await db.query(kTransactionsTable);

    if (data.isNotEmpty) {
      final List<TransactionModel> transactions = data
          .map<TransactionModel>(
              (transaction) => TransactionModel.fromJson(transaction))
          .toList();
      print("Transactions: $transactions");
      return transactions;
    } else {
      throw EmptyDatabaseException();
    }
  }

  @override
  Future<Unit> addTransaction(TransactionModel transaction) async {
    final db = await dbService.database;
    final data = transaction.toJson();
    final res = await db.insert(kTransactionsTable, data);
    print("Add Transaction res: $res");
    if (res > 0) {
      return Future.value(unit);
    } else {
      throw DatabaseAddException();
    }
  }

  @override
  Future<Unit> updateTransaction(TransactionModel transaction) async {
    final db = await dbService.database;
    final data = transaction.toJson();
    final res = await db.update(
      kTransactionsTable,
      data,
      where: 'id = ?',
      whereArgs: [transaction.id],
    );

    if (res == 0) {
      throw DatabaseEditException();
    } else {
      return Future.value(unit);
    }
  }

  @override
  Future<Unit> deleteTransaction(int id) async {
    final db = await dbService.database;
    final res = await db.delete(
      kTransactionsTable,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (res == 0) {
      throw DatabaseDeleteException();
    }

    return Future.value(unit);
  }
}
