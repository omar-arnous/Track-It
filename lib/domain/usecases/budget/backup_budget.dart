import 'package:dartz/dartz.dart';
import 'package:trackit/core/errors/failures.dart';
import 'package:trackit/domain/repositories/budget_repository.dart';

class BackupBudgetUsecase {
  final BudgetRepository repository;

  BackupBudgetUsecase({required this.repository});

  Future<Either<Failure, Unit>> call() async {
    return await repository.backupBudgets();
  }
}
