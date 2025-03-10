import 'package:dartz/dartz.dart';
import 'package:trackit/core/errors/failures.dart';
import 'package:trackit/domain/entities/exchange_rate.dart';
import 'package:trackit/domain/repositories/exchange_rate_repository.dart';

class AddExchangeRateUsecase {
  final ExchangeRateRepository repository;

  AddExchangeRateUsecase({required this.repository});

  Future<Either<Failure, Unit>> call(ExchangeRate rate) async {
    return await repository.addExchangeRate(rate);
  }
}
