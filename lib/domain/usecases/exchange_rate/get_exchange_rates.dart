import 'package:dartz/dartz.dart';
import 'package:trackit/core/errors/failures.dart';
import 'package:trackit/domain/entities/exchange_rate.dart';
import 'package:trackit/domain/repositories/exchange_rate_repository.dart';

class GetExchangeRates {
  final ExchangeRateRepository repository;

  GetExchangeRates({required this.repository});

  Future<Either<Failure, List<ExchangeRate>>> call() async {
    return await repository.getExchangeRates();
  }
}
