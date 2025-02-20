import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trackit/domain/repositories/transaction_repository.dart';
import 'package:trackit/domain/usecases/transaction/delete_transaction.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  late DeleteTransactionUsecase usecase;
  late MockTransactionRepository mockRepository;

  setUp(() {
    mockRepository = MockTransactionRepository();
    usecase = DeleteTransactionUsecase(repository: mockRepository);
  });

  test('should return nothing when deleting a new transaction', () async {
    when(() => mockRepository.deleteTransaction(1))
        .thenAnswer((_) async => const Right(unit));

    final result = await usecase(1);

    expect(result, const Right(unit));
    verify(() => mockRepository.deleteTransaction(1)).called(1);
  });
}
