import 'package:dartz/dartz.dart';
import 'package:trackit/core/errors/failures.dart';
import 'package:trackit/domain/entities/budget.dart';
import 'package:trackit/domain/repositories/budget_repository.dart';

class AddBudgetUsecase {
  final BudgetRepository repository;

  AddBudgetUsecase({required this.repository});

  Future<Either<Failure, Unit>> call(Budget budget) async {
    return await repository.addBudget(budget);
  }
}
