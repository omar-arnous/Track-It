import 'package:dartz/dartz.dart';
import 'package:trackit/core/errors/failures.dart';
import 'package:trackit/domain/entities/account.dart';

abstract class AccountRepository {
  Future<Either<Failure, List<Account>>> getAccounts();
  Future<Either<Failure, Unit>> restoreAccounts();
  Future<Either<Failure, Unit>> backupAccounts();
  Future<Either<Failure, Unit>> addAccount(Account account);
  Future<Either<Failure, Unit>> editAccount(Account account);
  Future<Either<Failure, Unit>> deleteAccount(int id);
  Future<Either<Failure, Account>> getSelectedAccount();
  Future<Either<Failure, Unit>> setSelectedAccount(Account account);
  Future<Either<Failure, Unit>> decreaseBalance(int id, double value);
  Future<Either<Failure, Unit>> increaseBalance(int id, double value);
  Future<Either<Failure, Unit>> reverseBalance(int id);
}
