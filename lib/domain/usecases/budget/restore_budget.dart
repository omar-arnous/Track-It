import 'package:dartz/dartz.dart';
import 'package:trackit/core/errors/failures.dart';
import 'package:trackit/domain/repositories/budget_repository.dart';

class RestoreBudgetUsecase {
  final BudgetRepository repository;

  RestoreBudgetUsecase({required this.repository});

  Future<Either<Failure, Unit>> call() async {
    return await repository.restoreBudgets();
  }
}
