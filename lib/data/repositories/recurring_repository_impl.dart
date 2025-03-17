import 'package:dartz/dartz.dart';
import 'package:trackit/core/errors/failures.dart';
import 'package:trackit/domain/entities/recurring.dart';
import 'package:trackit/domain/repositories/recurring_repository.dart';

class RecurringRepositoryImpl implements RecurringRepository {
  @override
  Future<Either<Failure, List<Recurring>>> getRecurringsPayments() {
    // TODO: implement getRecurringsPayments
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Unit>> addRecurringPayment(
      Recurring recurringPayment) {
    // TODO: implement addRecurringPayment
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Unit>> editRecurringPayment(
      Recurring recurringPayment) {
    // TODO: implement editRecurringPayment
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Unit>> deleteRecurringPayment(int id) {
    // TODO: implement deleteRecurringPayment
    throw UnimplementedError();
  }
}
