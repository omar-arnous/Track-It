import 'package:dartz/dartz.dart';
import 'package:trackit/config/local_service.dart';
import 'package:trackit/core/constants/db_constants.dart';
import 'package:trackit/core/errors/exceptions.dart';
import 'package:trackit/data/models/account_model.dart';
import 'package:trackit/data/models/budget_model.dart';

abstract class BudgetLocalDatasource {
  Future<List<BudgetModel>> getBudgets();
  Future<Unit> addBudget(BudgetModel budget);
  Future<Unit> updateBudget(BudgetModel budget);
  Future<Unit> deleteBudget(int id);
}

class BudgetLocalDatasourceImpl implements BudgetLocalDatasource {
  LocalService dbService;
  BudgetLocalDatasourceImpl({required this.dbService});

  @override
  Future<List<BudgetModel>> getBudgets() async {
    final db = await dbService.database;
    final data = await db.query(
      kBudgetsTable,
      orderBy: "start_date DESC",
    );

    if (data.isNotEmpty) {
      List<BudgetModel> budgets = [];
      for (var budget in data) {
        final accountData = await db.query(
          kAccountsTable,
          where: "id = ?",
          whereArgs: [budget['account_id']],
        );
        final account = AccountModel.fromJson(accountData.first);
        budgets.add(
          BudgetModel.fromJson(budget, account),
        );
      }

      return budgets;
    } else {
      throw EmptyDatabaseException();
    }
  }

  @override
  Future<Unit> addBudget(BudgetModel budget) async {
    final db = await dbService.database;
    final data = budget.toJson();
    final res = await db.insert(kBudgetsTable, data);

    if (res > 0) {
      return Future.value(unit);
    } else {
      throw DatabaseAddException();
    }
  }

  @override
  Future<Unit> updateBudget(BudgetModel budget) async {
    final db = await dbService.database;
    final data = budget.toJson();
    final res = await db.update(
      kBudgetsTable,
      data,
      where: 'id = ?',
      whereArgs: [budget.id],
    );

    if (res == 0) {
      throw DatabaseEditException();
    } else {
      return Future.value(unit);
    }
  }

  @override
  Future<Unit> deleteBudget(int id) async {
    final db = await dbService.database;
    final res = await db.delete(
      kBudgetsTable,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (res == 0) {
      throw DatabaseDeleteException();
    }

    return Future.value(unit);
  }
}
