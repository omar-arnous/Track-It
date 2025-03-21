import 'package:dartz/dartz.dart';
import 'package:trackit/config/local_service.dart';
import 'package:trackit/core/constants/db_constants.dart';
import 'package:trackit/core/errors/exceptions.dart';
import 'package:trackit/data/models/account_model.dart';

abstract class AccountLocalDatasource {
  Future<List<AccountModel>> getAccounts();
  Future<Unit> addAccount(AccountModel account);
  Future<Unit> editAccount(AccountModel account);
  Future<Unit> deleteAccount(int id);
  Future<Unit> decreaseBalance(int id, double value);
  Future<Unit> increaseBalance(int id, double value);
  Future<Unit> reverseBalance(int id);
}

class AccountLocalDatasourceImpl implements AccountLocalDatasource {
  LocalService dbService;
  AccountLocalDatasourceImpl({required this.dbService});

  @override
  Future<List<AccountModel>> getAccounts() async {
    final db = await dbService.database;
    final data = await db.query(kAccountsTable);

    if (data.isNotEmpty) {
      final List<AccountModel> accounts = data
          .map<AccountModel>((account) => AccountModel.fromJson(account))
          .toList();
      return accounts;
    } else {
      throw EmptyDatabaseException();
    }
  }

  @override
  Future<Unit> addAccount(AccountModel account) async {
    final db = await dbService.database;
    final data = account.toJson();
    final res = await db.insert(kAccountsTable, data);
    if (res > 0) {
      return Future.value(unit);
    } else {
      throw DatabaseAddException();
    }
  }

  @override
  Future<Unit> editAccount(AccountModel account) async {
    final db = await dbService.database;
    final data = account.toJson();
    final res = await db.update(
      kAccountsTable,
      data,
      where: 'id = ?',
      whereArgs: [account.id],
    );

    if (res == 0) {
      throw DatabaseEditException();
    } else {
      return Future.value(unit);
    }
  }

  @override
  Future<Unit> deleteAccount(int id) async {
    final db = await dbService.database;
    final res = await db.delete(
      kAccountsTable,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (res == 0) {
      throw DatabaseDeleteException();
    }

    return Future.value(unit);
  }

  @override
  Future<Unit> decreaseBalance(int id, double value) async {
    final db = await dbService.database;
    List<Map<String, dynamic>> accounts = await db.query(
      kAccountsTable,
      columns: ['balance', 'old_balance', 'total_expenses'],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (accounts.isNotEmpty) {
      double currentBalance = accounts.first['balance'];
      double totalExpenses = accounts.first['total_expenses'];

      double newBalance = currentBalance - value;
      double newTotlaExpenses = totalExpenses + value;

      final res = await db.update(
        kAccountsTable,
        {
          'balance': newBalance,
          'old_balance': currentBalance,
          'total_expenses': newTotlaExpenses
        },
        where: 'id = ?',
        whereArgs: [id],
      );

      if (res == 0) {
        throw DatabaseEditException();
      } else {
        return Future.value(unit);
      }
    } else {
      throw EmptyDatabaseException();
    }
  }

  @override
  Future<Unit> increaseBalance(int id, double value) async {
    final db = await dbService.database;
    List<Map<String, dynamic>> accounts = await db.query(
      kAccountsTable,
      columns: ['balance', 'old_balance', 'total_incomes'],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (accounts.isNotEmpty) {
      double currentBalance = accounts.first['balance'];
      double totalIncomes = accounts.first['total_incomes'];

      double newBalance = currentBalance + value;
      double newTotalIncomes = totalIncomes + value;

      final res = await db.update(
        kAccountsTable,
        {
          'balance': newBalance,
          'old_balance': currentBalance,
          'total_incomes': newTotalIncomes
        },
        where: 'id = ?',
        whereArgs: [id],
      );

      if (res == 0) {
        throw DatabaseEditException();
      } else {
        return Future.value(unit);
      }
    } else {
      throw EmptyDatabaseException();
    }
  }

  @override
  Future<Unit> reverseBalance(int id) async {
    final db = await dbService.database;
    List<Map<String, dynamic>> accounts = await db.query(
      kAccountsTable,
      where: "id = ?",
      whereArgs: [id],
    );

    if (accounts.isNotEmpty) {
      final account = accounts.first;

      final res = await db.update(
        kAccountsTable,
        {
          "balance": account['old_balance'],
          "old_balance": account['balance'],
        },
        where: 'id = ?',
        whereArgs: [id],
      );

      if (res == 0) {
        throw DatabaseEditException();
      } else {
        return Future.value(unit);
      }
    } else {
      throw EmptyDatabaseException();
    }
  }
}
