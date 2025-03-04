import 'package:dartz/dartz.dart';
import 'package:trackit/core/errors/exceptions.dart';
import 'package:trackit/core/errors/failures.dart';
import 'package:trackit/data/datasources/account/account_cache_datasource.dart';
import 'package:trackit/data/datasources/account/account_local_datasource.dart';
import 'package:trackit/data/models/account_model.dart';
import 'package:trackit/domain/entities/account.dart';
import 'package:trackit/domain/repositories/account_repository.dart';

class AccountRepositoryImpl implements AccountRepository {
  final AccountLocalDatasource localDatasource;
  final AccountCacheDatasource cacheDatasource;

  AccountRepositoryImpl({
    required this.localDatasource,
    required this.cacheDatasource,
  });

  @override
  Future<Either<Failure, List<Account>>> getAccounts() async {
    try {
      final accounts = await localDatasource.getAccounts();
      return Right(accounts);
    } on EmptyDatabaseException {
      return Left(EmptyDatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> addAccount(Account account) async {
    try {
      final data = AccountModel(
        name: account.name,
        type: account.type,
        balance: account.balance,
        oldBalance: account.oldBalance,
        totalExpenses: account.totalExpenses,
        totalIncomes: account.totalIncomes,
        color: account.color,
        currency: account.currency,
      );

      await localDatasource.addAccount(data);
      return const Right(unit);
    } on DatabaseAddException {
      return Left(DatabaseAddFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> editAccount(Account account) async {
    try {
      final data = AccountModel(
        id: account.id,
        name: account.name,
        type: account.type,
        balance: account.balance,
        oldBalance: account.oldBalance,
        totalExpenses: account.totalExpenses,
        totalIncomes: account.totalIncomes,
        color: account.color,
        currency: account.currency,
      );

      await localDatasource.editAccount(data);
      return const Right(unit);
    } on DatabaseEditException {
      return Left(DatabaseEditFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteAccount(int id) async {
    try {
      await localDatasource.deleteAccount(id);
      return const Right(unit);
    } on DatabaseDeleteException {
      return Left(DatabaseDeleteFailure());
    }
  }

  @override
  Future<Either<Failure, Account>> getSelectedAccount() async {
    try {
      final account = await cacheDatasource.getCachedAccount();
      return Right(account);
    } on EmptyCacheException {
      return Left(EmptyCacheFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> setSelectedAccount(Account account) async {
    try {
      final AccountModel accountModel = AccountModel(
        id: account.id,
        name: account.name,
        type: account.type,
        balance: account.balance,
        oldBalance: account.oldBalance,
        totalExpenses: account.totalExpenses,
        totalIncomes: account.totalIncomes,
        currency: account.currency,
      );
      await cacheDatasource.cacheAccount(accountModel);
      return const Right(unit);
    } on EmptyCacheException {
      return Left(EmptyCacheFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> decreaseBalance(int id, double value) async {
    try {
      await localDatasource.decreaseBalance(id, value);
      return const Right(unit);
    } on DatabaseEditException {
      return Left(DatabaseEditFailure());
    } on EmptyDatabaseException {
      return Left(EmptyDatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> increaseBalance(int id, double value) async {
    try {
      await localDatasource.increaseBalance(id, value);
      return const Right(unit);
    } on DatabaseEditException {
      return Left(DatabaseEditFailure());
    } on EmptyDatabaseException {
      return Left(EmptyDatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> reverseBalance(int id) async {
    try {
      await localDatasource.reverseBalance(id);
      return const Right(unit);
    } on DatabaseEditException {
      return Left(DatabaseEditFailure());
    }
  }
}
