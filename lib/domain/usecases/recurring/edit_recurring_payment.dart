import 'package:dartz/dartz.dart';
import 'package:trackit/core/errors/failures.dart';
import 'package:trackit/domain/entities/recurring.dart';
import 'package:trackit/domain/repositories/recurring_repository.dart';

class EditRecurringPaymentsUsecase {
  final RecurringRepository repository;

  EditRecurringPaymentsUsecase({required this.repository});

  Future<Either<Failure, Unit>> call(Recurring recurringPayment) async {
    return await repository.editRecurringPayment(recurringPayment);
  }
}
