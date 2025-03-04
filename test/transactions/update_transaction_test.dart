import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trackit/data/models/category_model.dart';
import 'package:trackit/data/models/transaction_model.dart';
import 'package:trackit/domain/entities/account.dart';
import 'package:trackit/domain/entities/account_type.dart';
import 'package:trackit/domain/entities/currency_type.dart';
import 'package:trackit/domain/entities/payment_type.dart';
import 'package:trackit/domain/entities/transaction_type.dart';
import 'package:trackit/domain/repositories/transaction_repository.dart';
import 'package:trackit/domain/usecases/transaction/update_transaction.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  late UpdateTransactionUsecase usecase;
  late MockTransactionRepository mockRepository;

  setUp(() {
    mockRepository = MockTransactionRepository();
    usecase = UpdateTransactionUsecase(repository: mockRepository);
  });

  test('should return nothing when updating a new transaction', () async {
    final transaction = TransactionModel(
      id: 1,
      transactionType: TransactionType.income,
      amount: 1000,
      paymentType: PaymentType.cash,
      currency: CurrencyType.syp,
      exchangeRate: 0,
      convertedAmount: 0.0,
      note: "updated transaction",
      date: DateTime.now(),
      time: TimeOfDay.now(),
      account: const Account(
        name: 'wallet',
        type: AccountType.cash,
        balance: 0,
        oldBalance: 0,
        totalExpenses: 0,
        totalIncomes: 0,
        currency: CurrencyType.syp,
      ),
      targetAccount: const Account(
        name: 'wallet',
        type: AccountType.cash,
        balance: 0,
        oldBalance: 0,
        totalExpenses: 0,
        totalIncomes: 0,
        currency: CurrencyType.syp,
      ),
      category: const CategoryModel(
        id: 1,
        name: 'test',
        icon: Icons.add,
        color: Colors.grey,
      ),
    );

    when(() => mockRepository.updateTransaction(transaction))
        .thenAnswer((_) async => const Right(unit));

    final result = await usecase(transaction);

    expect(result, const Right(unit));
    verify(() => mockRepository.updateTransaction(transaction)).called(1);
  });
}
