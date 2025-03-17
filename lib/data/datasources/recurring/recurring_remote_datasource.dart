import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:trackit/config/local_service.dart';
import 'package:trackit/core/constants/db_constants.dart';
import 'package:trackit/core/errors/exceptions.dart';
import 'package:trackit/data/models/account_model.dart';
import 'package:trackit/data/models/category_model.dart';
import 'package:trackit/data/models/recurring_model.dart';

abstract class RecurringRemoteDatasource {
  Stream<Iterable<RecurringModel>> getRecurringPayments();
  Future<Unit> addRecurringPayments(List<RecurringModel> recurringPayments);
}

class RecurringRemoteDatasourceImpl implements RecurringRemoteDatasource {
  FirebaseFirestore firestore;
  LocalService dbService;

  RecurringRemoteDatasourceImpl({
    required this.firestore,
    required this.dbService,
  });
  @override
  Stream<Iterable<RecurringModel>> getRecurringPayments() async* {
    final recurringCollection = firestore.collection('recurring_payments');
    final db = await dbService.database;

    yield* recurringCollection.snapshots().asyncMap((event) async {
      return Future.wait(event.docs.map((snapshot) async {
        final data = snapshot.data();

        final accountId = data['account_id'];
        final categoryId = data['category_id'];

        final account =
            await firestore.collection('accounts').doc(accountId).get();
        final category = await db.query(
          kCategoriesTable,
          where: "id = ?",
          whereArgs: [categoryId],
        );
        return RecurringModel.fromSnapshot(
          snapshot,
          AccountModel.fromJson(account.data() ?? {}),
          CategoryModel.fromJson(category.first),
        );
      }));
    });
  }

  @override
  Future<Unit> addRecurringPayments(
      List<RecurringModel> recurringPayments) async {
    try {
      final recurringCollection = firestore.collection('recurring_payments');
      for (var recurringPayment in recurringPayments) {
        final querySnapshot = await recurringCollection
            .where('id', isEqualTo: recurringPayment.id)
            .get();

        if (querySnapshot.docs.isEmpty) {
          continue;
        }

        await recurringCollection.add(recurringPayment.toJson());
      }
      return Future.value(unit);
    } on FirebaseException catch (_) {
      throw FirestoreAddException();
    }
  }
}
