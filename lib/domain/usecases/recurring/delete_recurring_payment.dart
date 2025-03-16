import 'package:dartz/dartz.dart';
import 'package:trackit/core/errors/failures.dart';
import 'package:trackit/domain/repositories/recurring_repository.dart';

class DeleteRecurringPaymentsUsecase {
  final RecurringRepository repository;

  DeleteRecurringPaymentsUsecase({required this.repository});

  Future<Either<Failure, Unit>> call(int id) async {
    return await repository.deleteRecurringPayment(id);
  }
}
