import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:trackit/config/local_service.dart';
import 'package:trackit/core/constants/db_constants.dart';
import 'package:trackit/core/errors/exceptions.dart';
import 'package:trackit/data/models/account_model.dart';
import 'package:trackit/data/models/category_model.dart';
import 'package:trackit/data/models/transaction_model.dart';

abstract class TransactionRemoteDatasource {
  Stream<Iterable<TransactionModel>> getTransactions();
  Future<Unit> addTransactions(List<TransactionModel> transactions);
}

class TransactionRemoteDatasourceImpl implements TransactionRemoteDatasource {
  FirebaseFirestore firestore;
  LocalService dbService;
  TransactionRemoteDatasourceImpl({
    required this.firestore,
    required this.dbService,
  });
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

        if (querySnapshot.docs.isEmpty) {
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
  Stream<Iterable<TransactionModel>> getTransactions() async* {
    final transactionCollection = firestore.collection('transactions');
    final db = await dbService.database;

    yield* transactionCollection.snapshots().asyncMap((event) async {
      return Future.wait(
        event.docs.map(
          (snapshot) async {
            final data = snapshot.data();

            final accountId = data['account_id'];
            final targetAccountId = data['target_account_id'];
            final categoryId = data['category_id'];

            final account =
                await firestore.collection('accounts').doc(accountId).get();
            final targetAccount = await firestore
                .collection('accounts')
                .doc(targetAccountId)
                .get();
            final category = await db.query(
              kCategoriesTable,
              where: "id = ?",
              whereArgs: [categoryId],
            );
            return TransactionModel.fromSnapshot(
              snapshot,
              AccountModel.fromJson(account.data() ?? {}),
              AccountModel.fromJson(targetAccount.data() ?? {}),
              CategoryModel.fromJson(category.first),
            );
          },
        ),
      );
    });

    // final transactions =
    //     transactionCollection.snapshots().asyncMap((event) async {
    //   return Future.wait(
    //     event.docs.map(
    //       (snapshot) async {
    //         final data = snapshot.data();

    //         final accountId = data['account_id'];
    //         final targetAccountId = data['target_account_id'];
    //         final categoryId = data['category_id'];

    //         final account =
    //             await firestore.collection('accounts').doc(accountId).get();
    //         final targetAccount = await firestore
    //             .collection('accounts')
    //             .doc(targetAccountId)
    //             .get();
    //         final category = await db.query(
    //           kCategoriesTable,
    //           where: "id = ?",
    //           whereArgs: [categoryId],
    //         );
    //         return TransactionModel.fromSnapshot(
    //           snapshot,
    //           AccountModel.fromJson(account.data() ?? {}),
    //           AccountModel.fromJson(targetAccount.data() ?? {}),
    //           CategoryModel.fromJson(category.first),
    //         );
    //       },
    //     ),
    //   );
    // });

    // return transactions;
  }
}
