import 'package:dartz/dartz.dart';
import 'package:trackit/core/errors/failures.dart';
import 'package:trackit/domain/entities/budget.dart';

abstract class BudgetRepository {
  Future<Either<Failure, List<Budget>>> getBudgets();
  Future<Either<Failure, Unit>> restoreBudgets();
  Future<Either<Failure, Unit>> backupBudgets(List<Budget> budgets);
  Future<Either<Failure, Unit>> addBudget(Budget budget);
  Future<Either<Failure, Unit>> updateBudget(Budget budget);
  Future<Either<Failure, Unit>> deleteBudget(int id);
}
