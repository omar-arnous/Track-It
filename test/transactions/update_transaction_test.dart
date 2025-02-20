import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trackit/data/models/transaction_model.dart';
import 'package:trackit/domain/entities/currency_type.dart';
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
      currency: CurrencyType.syp,
      exchangeRate: 0,
      convertedAmount: 0.0,
      note: "updated transaction",
      date: DateTime.now(),
      accountId: 1,
      targetAccountId: 1,
      categoryId: 1,
    );

    when(() => mockRepository.updateTransaction(transaction))
        .thenAnswer((_) async => const Right(unit));

    final result = await usecase(transaction);

    expect(result, const Right(unit));
    verify(() => mockRepository.updateTransaction(transaction)).called(1);
  });
}
