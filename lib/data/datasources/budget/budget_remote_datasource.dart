import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:trackit/core/errors/exceptions.dart';
import 'package:trackit/data/models/account_model.dart';
import 'package:trackit/data/models/budget_model.dart';

abstract class BudgetRemoteDatasource {
  Stream<Iterable<BudgetModel>> getBudgets();
  Future<Unit> addBudgets(List<BudgetModel> budgets);
}

class BudgetRemoteDatasourceImpl implements BudgetRemoteDatasource {
  FirebaseFirestore firestore;
  BudgetRemoteDatasourceImpl({required this.firestore});

  @override
  Future<Unit> addBudgets(List<BudgetModel> budgets) async {
    try {
      final budgetsCollection = firestore.collection('budgets');
      for (var budget in budgets) {
        final querySnapshot = await budgetsCollection
            .where(
              'id',
              isEqualTo: budget.id,
            )
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          continue;
        }

        await budgetsCollection.add(budget.toJson());
      }

      return Future.value(unit);
    } on FirebaseException catch (_) {
      throw FirestoreAddException();
    }
  }

  @override
  Stream<Iterable<BudgetModel>> getBudgets() {
    final budgetCollection = firestore.collection('budgets');

    final budgets = budgetCollection.snapshots().asyncMap((event) async {
      return Future.wait(
        event.docs.map(
          (snapshot) async {
            final data = snapshot.data();

            final accountId = data['account_id'];
            final account =
                await firestore.collection('accounts').doc(accountId).get();
            return BudgetModel.fromSnapshot(
              snapshot,
              AccountModel.fromJson(
                account.data() ?? {},
              ),
            );
          },
        ),
      );
    });

    return budgets;
  }
}
