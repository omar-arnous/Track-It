import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackit/core/constants/cache_constants.dart';
import 'package:trackit/core/errors/exceptions.dart';
import 'package:trackit/data/models/account_model.dart';

abstract class AccountCacheDatasource {
  Future<AccountModel> getCachedAccount();
  Future<Unit> cacheAccount(int id);
}

class AccountCacheDatasourceImpl implements AccountCacheDatasource {
  final SharedPreferences sharedPreferences;

  AccountCacheDatasourceImpl({required this.sharedPreferences});

  @override
  Future<Unit> cacheAccount(int id) {
    sharedPreferences.setString(kSelectedAccountKey, json.encode({"id": id}));
    return Future.value(unit);
  }

  @override
  Future<AccountModel> getCachedAccount() {
    final jsonData = sharedPreferences.getString(kSelectedAccountKey);
    if (jsonData != null) {
      final data = json.decode(jsonData);
      final account = AccountModel.fromJson(data);
      return Future.value(account);
    } else {
      throw EmptyCacheException();
    }
  }
}
