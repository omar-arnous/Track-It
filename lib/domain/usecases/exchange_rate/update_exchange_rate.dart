import 'package:dartz/dartz.dart';
import 'package:trackit/core/errors/failures.dart';
import 'package:trackit/domain/entities/exchange_rate.dart';
import 'package:trackit/domain/repositories/exchange_rate_repository.dart';

class UpdateExchangeRate {
  final ExchangeRateRepository repository;

  UpdateExchangeRate({required this.repository});

  Future<Either<Failure, Unit>> call(ExchangeRate rate) async {
    return await repository.updateExchangeRate(rate);
  }
}
