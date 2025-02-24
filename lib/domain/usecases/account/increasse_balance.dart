import 'package:dartz/dartz.dart';
import 'package:trackit/core/errors/failures.dart';
import 'package:trackit/domain/repositories/account_repository.dart';

class IncreaseBalanceUsecase {
  final AccountRepository repository;

  IncreaseBalanceUsecase({required this.repository});

  Future<Either<Failure, Unit>> call(int id, double value) async {
    return await repository.increaseBalance(id, value);
  }
}
