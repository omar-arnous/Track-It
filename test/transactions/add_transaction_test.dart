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
import 'package:trackit/domain/usecases/transaction/add_transaction.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  late AddTransactionUsecase usecase;
  late MockTransactionRepository mockRepository;

  setUp(() {
    mockRepository = MockTransactionRepository();
    usecase = AddTransactionUsecase(repository: mockRepository);
  });

  test('should return nothing when adding a new transaction', () async {
    final transaction = TransactionModel(
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
        oldBalance: 0,
        currency: CurrencyType.syp,
      ),
      targetAccount: const Account(
        name: 'wallet',
        type: AccountType.cash,
        balance: 0,
        oldBalance: 0,
        currency: CurrencyType.syp,
      ),
      category: const CategoryModel(
        id: 1,
        name: 'test',
        icon: Icons.add,
        color: Colors.grey,
      ),
    );

    when(() => mockRepository.addTransaction(transaction))
        .thenAnswer((_) async => const Right(unit));

    final result = await usecase(transaction);

    expect(result, const Right(unit));
    verify(() => mockRepository.addTransaction(transaction)).called(1);
  });
}
