import 'package:dartz/dartz.dart';
import 'package:trackit/config/local_service.dart';
import 'package:trackit/core/constants/db_constants.dart';
import 'package:trackit/core/errors/exceptions.dart';
import 'package:trackit/data/models/exchange_rate_model.dart';

abstract class ExchangeRateLocalDataSource {
  Future<List<ExchangeRateModel>> getExchangeRates();
  Future<Unit> addExchangeRate(ExchangeRateModel rateModel);
  Future<Unit> updateExchangeRate(ExchangeRateModel rateModel);
}

class ExchangeRateLocalDataSourceImpl implements ExchangeRateLocalDataSource {
  LocalService dbService;
  ExchangeRateLocalDataSourceImpl({required this.dbService});

  @override
  Future<List<ExchangeRateModel>> getExchangeRates() async {
    final db = await dbService.database;
    final data = await db.query(kExchangeRateTable);

    if (data.isNotEmpty) {
      List<ExchangeRateModel> exchangeRates = data
          .map<ExchangeRateModel>((rate) => ExchangeRateModel.fromJson(rate))
          .toList();

      return exchangeRates;
    } else {
      throw EmptyDatabaseException();
    }
  }

  @override
  Future<Unit> addExchangeRate(ExchangeRateModel rateModel) async {
    final db = await dbService.database;
    final data = rateModel.toJson();
    final res = await db.insert(kExchangeRateTable, data);
    if (res > 0) {
      return Future.value(unit);
    } else {
      throw DatabaseAddException();
    }
  }

  @override
  Future<Unit> updateExchangeRate(ExchangeRateModel rateModel) async {
    final db = await dbService.database;
    final data = rateModel.toJson();
    final res = await db.update(
      kExchangeRateTable,
      data,
      where: 'id = ?',
      whereArgs: [rateModel.id],
    );

    if (res == 0) {
      throw DatabaseEditException();
    } else {
      return Future.value(unit);
    }
  }
}
