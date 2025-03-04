import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:trackit/core/errors/exceptions.dart';
import 'package:trackit/data/models/transaction_model.dart';
import 'package:trackit/domain/entities/account.dart';
import 'package:trackit/domain/entities/category.dart';

abstract class TransactionRemoteDatasource {
  Stream<Iterable<TransactionModel>> getTransactions(
      Account account, Account targetAccount, Category category);
  Future<Unit> addTransactions(List<TransactionModel> transactions);
}

class TransactionRemoteDatasourceImpl implements TransactionRemoteDatasource {
  FirebaseFirestore firestore;
  TransactionRemoteDatasourceImpl({required this.firestore});
  @override
  Future<Unit> addTransactions(List<TransactionModel> transactions) async {
    try {
      final transactionCollection = firestore.collection('transactions');
      for (var transaction in transactions) {
        final querySnapshot = await transactionCollection
            .where(
              'id',
              isEqualTo: transaction.id,
            )
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          continue;
        }

        await transactionCollection.add(transaction.toJson());
      }

      return Future.value(unit);
    } on FirebaseException catch (_) {
      throw FirestoreAddException();
    }
  }

  @override
  Stream<Iterable<TransactionModel>> getTransactions(
      Account account, Account targetAccount, Category category) {
    final transactionCollection = firestore.collection('transactions');

    final transactions = transactionCollection.snapshots().map((event) =>
        event.docs.map((snapshot) => TransactionModel.fromSnapshot(
            snapshot, account, targetAccount, category)));

    return transactions;
  }
}
