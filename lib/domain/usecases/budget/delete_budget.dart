import 'package:dartz/dartz.dart';
import 'package:trackit/core/errors/failures.dart';
import 'package:trackit/domain/repositories/budget_repository.dart';

class DeleteBudgetUsecase {
  final BudgetRepository repository;

  DeleteBudgetUsecase({required this.repository});

  Future<Either<Failure, Unit>> call(int id) async {
    return await repository.deleteBudget(id);
  }
}
