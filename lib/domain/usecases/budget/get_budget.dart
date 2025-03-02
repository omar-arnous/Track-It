import 'package:dartz/dartz.dart';
import 'package:trackit/core/errors/failures.dart';
import 'package:trackit/domain/entities/budget.dart';
import 'package:trackit/domain/repositories/budget_repository.dart';

class GetBudgetUsecase {
  final BudgetRepository repository;

  GetBudgetUsecase({required this.repository});

  Future<Either<Failure, List<Budget>>> call() async {
    return await repository.getBudgets();
  }
}
