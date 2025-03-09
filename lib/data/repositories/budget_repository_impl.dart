import 'package:dartz/dartz.dart';
import 'package:trackit/core/errors/exceptions.dart';
import 'package:trackit/core/errors/failures.dart';
import 'package:trackit/core/network/network_info.dart';
import 'package:trackit/data/datasources/budget/budget_local_datasource.dart';
import 'package:trackit/data/datasources/budget/budget_remote_datasource.dart';
import 'package:trackit/data/models/budget_model.dart';
import 'package:trackit/domain/entities/budget.dart';
import 'package:trackit/domain/repositories/budget_repository.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  final BudgetLocalDatasource localDatasource;
  final BudgetRemoteDatasource remoteDatasource;
  final NetworkInfo networkInfo;

  BudgetRepositoryImpl({
    required this.localDatasource,
    required this.remoteDatasource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Budget>>> getBudgets() async {
    try {
      final budgets = await localDatasource.getBudgets();
      return Right(budgets);
    } on EmptyDatabaseException {
      return Left(EmptyDatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> addBudget(Budget budget) async {
    try {
      final data = BudgetModel(
        amountLimit: budget.amountLimit,
        period: budget.period,
        startDate: budget.startDate,
        endDate: budget.endDate,
        account: budget.account,
      );

      await localDatasource.addBudget(data);
      return const Right(unit);
    } on DatabaseAddException {
      return Left(DatabaseAddFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateBudget(Budget budget) async {
    try {
      final data = BudgetModel(
        id: budget.id,
        amountLimit: budget.amountLimit,
        period: budget.period,
        startDate: budget.startDate,
        endDate: budget.endDate,
        account: budget.account,
      );

      await localDatasource.updateBudget(data);
      return const Right(unit);
    } on DatabaseEditException {
      return Left(DatabaseEditFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteBudget(int id) async {
    try {
      await localDatasource.deleteBudget(id);
      return const Right(unit);
    } on DatabaseDeleteException {
      return Left(DatabaseDeleteFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> backupBudgets(List<Budget> budgets) async {
    if (await networkInfo.isConnected) {
      final List<BudgetModel> budgetsData = [];
      try {
        for (var budget in budgets) {
          final budgetData = BudgetModel(
            id: budget.id,
            amountLimit: budget.amountLimit,
            period: budget.period,
            startDate: budget.startDate,
            endDate: budget.endDate,
            account: budget.account,
          );

          budgetsData.add(budgetData);
        }
        await remoteDatasource.addBudgets(budgetsData);
        return const Right(unit);
      } on FirestoreAddException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> restoreBudgets() async {
    if (await networkInfo.isConnected) {
      try {
        final stream = remoteDatasource.getBudgets();
        final budgets = await convertStreamToFuture(stream);
        for (var budget in budgets) {
          localDatasource.addBudget(budget);
        }
        return const Right(unit);
      } catch (_) {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }

  Future<List<BudgetModel>> convertStreamToFuture(
      Stream<Iterable<BudgetModel>> stream) async {
    final allBudgets = await stream
        .map((iterable) => iterable
            .toList()) // Convert each Iterable<AccountModel> to List<AccountModel>
        .fold<List<BudgetModel>>(
            [],
            (previous, current) =>
                previous..addAll(current)); // Collect all lists into one
    return allBudgets;
  }
}
