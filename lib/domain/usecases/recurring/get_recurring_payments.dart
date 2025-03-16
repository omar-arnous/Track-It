import 'package:dartz/dartz.dart';
import 'package:trackit/core/errors/failures.dart';
import 'package:trackit/domain/entities/recurring.dart';
import 'package:trackit/domain/repositories/recurring_repository.dart';

class GetRecurringPaymentsUsecase {
  final RecurringRepository repository;

  GetRecurringPaymentsUsecase({required this.repository});

  Future<Either<Failure, List<Recurring>>> call() async {
    return await repository.getRecurringsPayments();
  }
}
