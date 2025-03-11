import 'package:dartz/dartz.dart';
import 'package:trackit/config/local_service.dart';
import 'package:trackit/core/constants/db_constants.dart';
import 'package:trackit/core/errors/exceptions.dart';
import 'package:trackit/data/models/account_model.dart';
import 'package:trackit/data/models/category_model.dart';
import 'package:trackit/data/models/transaction_model.dart';
import 'package:trackit/domain/entities/currency_type.dart';
import 'package:trackit/domain/entities/transaction_type.dart';

abstract class TransactionLocalDatasource {
  Future<List<TransactionModel>> getTransactionByAccountId(int id);
  Future<List<TransactionModel>> getTransactions();
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
    final data = await db.query(
      kTransactionsTable,
      where: 'account_id = ?',
      whereArgs: [id],
      orderBy: "date DESC",
    );

    if (data.isNotEmpty) {
      List<TransactionModel> transactions = [];
      for (var transaction in data) {
        final accountData = await db.query(
          kAccountsTable,
          where: 'id = ?',
          whereArgs: [transaction['account_id']],
        );
        final account = AccountModel.fromJson(accountData.first);
        final targetAccountData = await db.query(
          kAccountsTable,
          where: 'id = ?',
          whereArgs: [transaction['target_account_id']],
        );
        final targetAccount = AccountModel.fromJson(targetAccountData.first);
        final categoryData = await db.query(
          kCategoriesTable,
          where: 'id = ?',
          whereArgs: [transaction['category_id']],
        );
        final category = CategoryModel.fromJson(categoryData.first);
        transactions.add(
          TransactionModel.fromJson(
              transaction, account, targetAccount, category),
        );
      }
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
      // final account = db.query(kAccountsTable, );
      return Future.value(unit);
    }
  }

  @override
  Future<Unit> deleteTransaction(int id) async {
    final db = await dbService.database;
    List<Map<String, dynamic>> transactions = await db.query(
      kTransactionsTable,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (transactions.isEmpty) {
      throw EmptyDatabaseException();
    }

    final transaction = transactions.first;

    List<Map<String, dynamic>> accounts = await db.query(
      kAccountsTable,
      where: 'id = ?',
      whereArgs: [
        transactions.first['account_id'],
      ],
    );

    if (accounts.isEmpty) {
      throw Exception("Account not found");
    }

    final account = accounts.first;

    double newBalance = account['balance'].toDouble();

    if (transaction['type'] == TransactionType.expense.toString()) {
      newBalance += transaction['amount'];
    } else if (transaction['type'] == TransactionType.income.toString()) {
      newBalance -= transaction['amount'];
    } else if (transaction['type'] == TransactionType.transfer.toString()) {
      List<Map<String, dynamic>> targetAccounts = await db.query(
        kAccountsTable,
        where: 'id = ?',
        whereArgs: [
          transactions.first['target_account_id'],
        ],
      );

      List<Map<String, dynamic>> exchangeRates =
          await db.query(kExchangeRateTable);

      if (exchangeRates.isEmpty) {
        throw Exception("No exchange rate found");
      }

      if (targetAccounts.isEmpty) {
        throw Exception("Target account not found");
      }

      final targetAccount = targetAccounts.first;
      double newTargetBalance = targetAccount['balance'].toDouble();

      final exchangeRate = exchangeRates.first;
      double rate = exchangeRate['rate'].toDouble();

      if (account['currency'] == CurrencyType.syp &&
          targetAccount['currency'] == CurrencyType.usd) {
        newBalance += transaction['amount'];
        newTargetBalance -= transaction['amount'] / rate;
      } else if (account['currency'] == CurrencyType.usd &&
          targetAccount['currency'] == CurrencyType.syp) {
        newBalance += transaction['amount'];
        newTargetBalance -= transaction['amount'] * rate;
      } else {
        newBalance += transaction['amount'];
        newTargetBalance -= transaction['amount'];
      }

      await db.update(
        kAccountsTable,
        {'balance': newTargetBalance},
        where: 'id = ?',
        whereArgs: [targetAccount['id']],
      );
    }

    await db.update(
      kAccountsTable,
      {'balance': newBalance},
      where: 'id = ?',
      whereArgs: [account['id']],
    );

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

  @override
  Future<List<TransactionModel>> getTransactions() async {
    final db = await dbService.database;
    final data = await db.query(kTransactionsTable);

    if (data.isNotEmpty) {
      List<TransactionModel> transactions = [];
      for (var transaction in data) {
        final accountData = await db.query(
          kAccountsTable,
          where: 'id = ?',
          whereArgs: [transaction['account_id']],
        );
        final account = AccountModel.fromJson(accountData.first);
        final targetAccountData = await db.query(
          kAccountsTable,
          where: 'id = ?',
          whereArgs: [transaction['target_account_id']],
        );
        final targetAccount = AccountModel.fromJson(targetAccountData.first);
        final categoryData = await db.query(
          kCategoriesTable,
          where: 'id = ?',
          whereArgs: [transaction['category_id']],
        );
        final category = CategoryModel.fromJson(categoryData.first);
        transactions.add(
          TransactionModel.fromJson(
              transaction, account, targetAccount, category),
        );
      }
      return transactions;
    } else {
      throw EmptyDatabaseException();
    }
  }
}
