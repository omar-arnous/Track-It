import 'package:dartz/dartz.dart';
import 'package:trackit/core/errors/failures.dart';
import 'package:trackit/domain/repositories/recurring_repository.dart';

class BackupRecurringPaymentsUsecase {
  final RecurringRepository repository;

  BackupRecurringPaymentsUsecase({required this.repository});

  Future<Either<Failure, Unit>> call() async {
    return await repository.backupRecurringPayments();
  }
}
