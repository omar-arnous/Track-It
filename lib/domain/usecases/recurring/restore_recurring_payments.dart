import 'package:dartz/dartz.dart';
import 'package:trackit/core/errors/failures.dart';
import 'package:trackit/domain/repositories/recurring_repository.dart';

class RestoreRecurringPaymentsUsecase {
  final RecurringRepository repository;

  RestoreRecurringPaymentsUsecase({required this.repository});

  Future<Either<Failure, Unit>> call() async {
    return await repository.restoreRecurringPayments();
  }
}
