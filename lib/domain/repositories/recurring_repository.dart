import 'package:dartz/dartz.dart';
import 'package:trackit/core/errors/failures.dart';
import 'package:trackit/domain/entities/recurring.dart';

abstract class RecurringRepository {
  Future<Either<Failure, List<Recurring>>> getRecurringsPayments();
  Future<Either<Failure, Unit>> restoreRecurringPayments();
  Future<Either<Failure, Unit>> backupRecurringPayments();
  Future<Either<Failure, Unit>> addRecurringPayment(Recurring recurringPayment);
  Future<Either<Failure, Unit>> editRecurringPayment(
      Recurring recurringPayment);
  Future<Either<Failure, Unit>> deleteRecurringPayment(int id);
}
