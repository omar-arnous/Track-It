import 'package:dartz/dartz.dart';
import 'package:trackit/config/local_service.dart';
import 'package:trackit/core/constants/db_constants.dart';
import 'package:trackit/core/errors/exceptions.dart';
import 'package:trackit/data/models/account_model.dart';
import 'package:trackit/data/models/category_model.dart';
import 'package:trackit/data/models/recurring_model.dart';

abstract class RecurringLocalDatasource {
  Future<List<RecurringModel>> getRecurringPayments();
  Future<Unit> addRecurringPayment(RecurringModel recurringPayment);
  Future<Unit> editRecurringPayment(RecurringModel recurringPayment);
  Future<Unit> deleteRecurringPayment(int id);
}

class RecurringLocalDatasourceImpl implements RecurringLocalDatasource {
  LocalService dbService;
  RecurringLocalDatasourceImpl({required this.dbService});

  @override
  Future<List<RecurringModel>> getRecurringPayments() async {
    final db = await dbService.database;
    final data = await db.query(
      kRecurringTransactionsTable,
      orderBy: "created_at DESC",
    );

    if (data.isNotEmpty) {
      List<RecurringModel> recurringPayments = [];
      for (var recurringPayment in data) {
        final accountData = await db.query(
          kAccountsTable,
          where: "id = ?",
          whereArgs: [recurringPayment['account_id']],
        );
        final account = AccountModel.fromJson(accountData.first);

        final categoryData = await db.query(
          kCategoriesTable,
          where: "id = ?",
          whereArgs: [recurringPayment['category_id']],
        );
        final category = CategoryModel.fromJson(categoryData.first);

        recurringPayments.add(
          RecurringModel.fromJson(recurringPayment, account, category),
        );
      }

      return recurringPayments;
    } else {
      throw EmptyDatabaseException();
    }
  }

  @override
  Future<Unit> addRecurringPayment(RecurringModel recurringPayment) async {
    final db = await dbService.database;
    final data = recurringPayment.toJson();
    final res = await db.insert(kRecurringTransactionsTable, data);

    if (res > 0) {
      return Future.value(unit);
    } else {
      throw DatabaseAddException();
    }
  }

  @override
  Future<Unit> editRecurringPayment(RecurringModel recurringPayment) async {
    final db = await dbService.database;
    final data = recurringPayment.toJson();
    final res = await db.update(
      kRecurringTransactionsTable,
      data,
      where: "id = ?",
      whereArgs: [recurringPayment.id],
    );

    if (res == 0) {
      throw DatabaseEditException();
    } else {
      return Future.value(unit);
    }
  }

  @override
  Future<Unit> deleteRecurringPayment(int id) async {
    final db = await dbService.database;
    final res = await db.delete(
      kRecurringTransactionsTable,
      where: "id = ?",
      whereArgs: [id],
    );

    if (res == 0) {
      throw DatabaseDeleteException();
    } else {
      return Future.value(unit);
    }
  }
}
