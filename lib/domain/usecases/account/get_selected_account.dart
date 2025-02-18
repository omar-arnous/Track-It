import 'package:dartz/dartz.dart';
import 'package:trackit/core/errors/failures.dart';
import 'package:trackit/domain/entities/account.dart';
import 'package:trackit/domain/repositories/account_repository.dart';

class GetSelectedAccountUsecase {
  final AccountRepository repository;

  GetSelectedAccountUsecase({required this.repository});

  Future<Either<Failure, Account>> call() async {
    return await repository.getSelectedAccount();
  }
}
