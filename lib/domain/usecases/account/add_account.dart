import 'package:dartz/dartz.dart';
import 'package:trackit/core/errors/failures.dart';
import 'package:trackit/domain/entities/account.dart';
import 'package:trackit/domain/repositories/account_repository.dart';

class AddAccountUsecase {
  final AccountRepository repository;

  AddAccountUsecase({required this.repository});

  Future<Either<Failure, Unit>> call(Account account) async {
    return await repository.addAccount(account);
  }
}
