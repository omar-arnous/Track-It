import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:trackit/core/errors/exceptions.dart';
import 'package:trackit/data/models/account_model.dart';

abstract class AccountRemoteDatasource {
  Stream<Iterable<AccountModel>> getAccounts();
  Future<Unit> addAccounts(List<AccountModel> accounts);
}

class AccountRemoteDatasourceImpl implements AccountRemoteDatasource {
  FirebaseFirestore firestore;
  AccountRemoteDatasourceImpl({required this.firestore});

  @override
  Future<Unit> addAccounts(List<AccountModel> accounts) async {
    try {
      final accountCollection = firestore.collection('accounts');
      for (var account in accounts) {
        final querySnapshot = await accountCollection
            .where(
              'email',
              isEqualTo: account.name,
            )
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          continue;
        }

        await accountCollection.add(account.toJson());
      }
      return Future.value(unit);
    } on FirebaseException catch (_) {
      throw FirestoreAddException();
    }
  }

  @override
  Stream<Iterable<AccountModel>> getAccounts() {
    final accountCollection = firestore.collection('accounts');

    final accounts = accountCollection.snapshots().map((event) =>
        event.docs.map((snapshot) => AccountModel.fromSnapshot(snapshot)));

    return accounts;
  }
}
