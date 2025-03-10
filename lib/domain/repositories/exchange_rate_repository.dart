import 'package:dartz/dartz.dart';
import 'package:trackit/core/errors/failures.dart';
import 'package:trackit/domain/entities/exchange_rate.dart';

abstract class ExchangeRateRepository {
  Future<Either<Failure, List<ExchangeRate>>> getExchangeRates();
  Future<Either<Failure, Unit>> addExchangeRate(ExchangeRate rate);
  Future<Either<Failure, Unit>> updateExchangeRate(ExchangeRate rate);
}
