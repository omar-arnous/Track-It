import 'package:dartz/dartz.dart';
import 'package:trackit/core/errors/exceptions.dart';
import 'package:trackit/core/errors/failures.dart';
import 'package:trackit/data/datasources/exchange_rate/exchange_rate_local_data_source.dart';
import 'package:trackit/data/models/exchange_rate_model.dart';
import 'package:trackit/domain/entities/exchange_rate.dart';
import 'package:trackit/domain/repositories/exchange_rate_repository.dart';

class ExchangeRateRepositoryImpl implements ExchangeRateRepository {
  final ExchangeRateLocalDataSource localDataSource;
  ExchangeRateRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<ExchangeRate>>> getExchangeRates() async {
    try {
      final exchangeRates = await localDataSource.getExchangeRates();
      return Right(exchangeRates);
    } on EmptyDatabaseException {
      return Left(EmptyDatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> addExchangeRate(ExchangeRate rate) async {
    try {
      final data = ExchangeRateModel(
        baseCurrency: rate.baseCurrency,
        targetCurrency: rate.targetCurrency,
        rate: rate.rate,
        updatedAt: rate.updatedAt,
      );
      await localDataSource.addExchangeRate(data);
      return const Right(unit);
    } on DatabaseAddException {
      return Left(DatabaseAddFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateExchangeRate(ExchangeRate rate) async {
    try {
      final data = ExchangeRateModel(
        id: rate.id,
        baseCurrency: rate.baseCurrency,
        targetCurrency: rate.targetCurrency,
        rate: rate.rate,
        updatedAt: rate.updatedAt,
      );
      await localDataSource.updateExchangeRate(data);
      return const Right(unit);
    } on DatabaseEditException {
      return Left(DatabaseEditFailure());
    }
  }
}
