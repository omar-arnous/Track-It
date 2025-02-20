import 'package:dartz/dartz.dart';
import 'package:trackit/core/errors/failures.dart';
import 'package:trackit/domain/repositories/transaction_repository.dart';

class DeleteTransactionUsecase {
  final TransactionRepository repository;

  DeleteTransactionUsecase({required this.repository});

  Future<Either<Failure, Unit>> call(int id) async {
    return await repository.deleteTransaction(id);
  }
}
