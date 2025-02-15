import 'package:dartz/dartz.dart';
import 'package:trackit/core/errors/failures.dart';
import 'package:trackit/domain/entities/account.dart';
import 'package:trackit/domain/repositories/account_repository.dart';

class GetAccountsUsecase {
  final AccountRepository repository;

  GetAccountsUsecase({required this.repository});

  Future<Either<Failure, List<Account>>> call() async {
    return await repository.getAccounts();
  }
}
