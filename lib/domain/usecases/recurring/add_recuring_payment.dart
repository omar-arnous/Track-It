import 'package:dartz/dartz.dart';
import 'package:trackit/core/errors/failures.dart';
import 'package:trackit/domain/entities/recurring.dart';
import 'package:trackit/domain/repositories/recurring_repository.dart';

class AddRecurringPaymentsUsecase {
  final RecurringRepository repository;

  AddRecurringPaymentsUsecase({required this.repository});

  Future<Either<Failure, Unit>> call(Recurring recurringPayment) async {
    return await repository.addRecurringPayment(recurringPayment);
  }
}
