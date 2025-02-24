import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trackit/core/errors/failures.dart';
import 'package:trackit/data/models/category_model.dart';
import 'package:trackit/domain/entities/account.dart';
import 'package:trackit/domain/entities/account_type.dart';
import 'package:trackit/domain/entities/currency_type.dart';
import 'package:trackit/domain/entities/payment_type.dart';
import 'package:trackit/domain/entities/transaction.dart';
import 'package:trackit/domain/entities/transaction_type.dart';
import 'package:trackit/domain/repositories/transaction_repository.dart';
import 'package:trackit/domain/usecases/transaction/get_transactions_by_account_id.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  late GetTransactionsByAccountIdUsecase usecase;
  late MockTransactionRepository mockRepository;

  setUp(() {
    mockRepository = MockTransactionRepository();
    usecase = GetTransactionsByAccountIdUsecase(repository: mockRepository);
  });

  test('should return a list of transactions', () async {
    final transactions = [
      Transaction(
        id: 1,
        transactionType: TransactionType.income,
        amount: 1000,
        paymentType: PaymentType.cash,
        currency: CurrencyType.syp,
        exchangeRate: 0,
        convertedAmount: 0.0,
        note: null,
        date: DateTime.now(),
        time: TimeOfDay.now(),
        account: const Account(
          name: 'wallet',
          type: AccountType.cash,
          balance: 0,
          currency: CurrencyType.syp,
        ),
        targetAccount: const Account(
          name: 'wallet',
          type: AccountType.cash,
          balance: 0,
          currency: CurrencyType.syp,
        ),
        category: const CategoryModel(
          id: 1,
          name: 'test',
          icon: Icons.add,
          color: Colors.grey,
        ),
      ),
    ];
    when(() => mockRepository.getTransactionsByAccountId(1))
        .thenAnswer((_) async => Right(transactions));

    final result = await usecase(1);

    expect(result, Right(transactions));
    verify(() => mockRepository.getTransactionsByAccountId(1)).called(1);
  });

  test('should return failure when an exception is occured', () async {
    final failure = EmptyDatabaseFailure();
    when(() => mockRepository.getTransactionsByAccountId(1))
        .thenAnswer((_) async => Left(failure));

    final result = await usecase(1);

    expect(result, Left(failure));
    verify(() => mockRepository.getTransactionsByAccountId(1)).called(1);
  });
}
