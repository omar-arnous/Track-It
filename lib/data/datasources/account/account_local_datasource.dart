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
}
