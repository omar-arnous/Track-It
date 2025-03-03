import 'package:dartz/dartz.dart';
import 'package:trackit/core/errors/exceptions.dart';
import 'package:trackit/core/errors/failures.dart';
import 'package:trackit/data/datasources/budget/budget_local_datasource.dart';
import 'package:trackit/data/models/budget_model.dart';
import 'package:trackit/domain/entities/budget.dart';
import 'package:trackit/domain/repositories/budget_repository.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  final BudgetLocalDatasource localDatasource;

  BudgetRepositoryImpl({required this.localDatasource});

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
}
