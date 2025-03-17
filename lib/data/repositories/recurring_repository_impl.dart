import 'package:dartz/dartz.dart';
import 'package:trackit/core/errors/exceptions.dart';
import 'package:trackit/core/errors/failures.dart';
import 'package:trackit/core/network/network_info.dart';
import 'package:trackit/data/datasources/recurring/recurring_local_datasource.dart';
import 'package:trackit/data/datasources/recurring/recurring_remote_datasource.dart';
import 'package:trackit/data/models/recurring_model.dart';
import 'package:trackit/domain/entities/recurring.dart';
import 'package:trackit/domain/repositories/recurring_repository.dart';

class RecurringRepositoryImpl implements RecurringRepository {
  final RecurringLocalDatasource localDatasource;
  final RecurringRemoteDatasource remoteDatasource;
  final NetworkInfo networkInfo;

  RecurringRepositoryImpl({
    required this.localDatasource,
    required this.networkInfo,
    required this.remoteDatasource,
  });

  @override
  Future<Either<Failure, List<Recurring>>> getRecurringsPayments() async {
    try {
      final recurringPayments = await localDatasource.getRecurringPayments();
      return Right(recurringPayments);
    } on EmptyDatabaseException {
      return Left(EmptyDatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> addRecurringPayment(
      Recurring recurringPayment) async {
    try {
      final data = RecurringModel(
        paymentType: recurringPayment.paymentType,
        amount: recurringPayment.amount,
        currencyType: recurringPayment.currencyType,
        frequency: recurringPayment.frequency,
        nextDueDate: recurringPayment.nextDueDate,
        createdAt: recurringPayment.createdAt,
        note: recurringPayment.note,
        account: recurringPayment.account,
        category: recurringPayment.category,
      );

      await localDatasource.addRecurringPayment(data);
      return const Right(unit);
    } on DatabaseAddException {
      return Left(DatabaseAddFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> editRecurringPayment(
      Recurring recurringPayment) async {
    try {
      final data = RecurringModel(
        id: recurringPayment.id,
        paymentType: recurringPayment.paymentType,
        amount: recurringPayment.amount,
        currencyType: recurringPayment.currencyType,
        frequency: recurringPayment.frequency,
        nextDueDate: recurringPayment.nextDueDate,
        createdAt: recurringPayment.createdAt,
        note: recurringPayment.note,
        account: recurringPayment.account,
        category: recurringPayment.category,
      );

      await localDatasource.editRecurringPayment(data);
      return const Right(unit);
    } on DatabaseEditException {
      return Left(DatabaseEditFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteRecurringPayment(int id) async {
    try {
      await localDatasource.deleteRecurringPayment(id);
      return const Right(unit);
    } on DatabaseDeleteException {
      return Left(DatabaseDeleteFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> backupRecurringPayments() async {
    if (await networkInfo.isConnected) {
      try {
        final recurringPayments = await localDatasource.getRecurringPayments();
        await remoteDatasource.addRecurringPayments(recurringPayments);
        return const Right(unit);
      } on EmptyDatabaseException {
        return Left(EmptyDatabaseFailure());
      } on FirestoreAddException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> restoreRecurringPayments() async {
    if (await networkInfo.isConnected) {
      try {
        final stream = remoteDatasource.getRecurringPayments();
        final recurringPayments = await convertStreamToFuture(stream);
        for (var recurringPayment in recurringPayments) {
          localDatasource.addRecurringPayment(recurringPayment);
        }
        return const Right(unit);
      } catch (_) {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }

  Future<List<RecurringModel>> convertStreamToFuture(
      Stream<Iterable<RecurringModel>> stream) async {
    final allRecurringPayments = await stream
        .map((iterable) => iterable
            .toList()) // Convert each Iterable<AccountModel> to List<AccountModel>
        .fold<List<RecurringModel>>(
            [],
            (previous, current) =>
                previous..addAll(current)); // Collect all lists into one
    return allRecurringPayments;
  }
}
