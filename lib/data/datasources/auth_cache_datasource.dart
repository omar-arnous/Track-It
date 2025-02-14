import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackit/core/constants/cache_constants.dart';
import 'package:trackit/core/errors/exceptions.dart';
import 'package:trackit/data/models/user_model.dart';

abstract class AuthCacheDatasource {
  Future<UserModel> getCachedUser();
  Future<Unit> cacheUser(UserModel user);
  Future<Unit> clearUser();
}

class AuthCacheDatasourceImpl implements AuthCacheDatasource {
  final SharedPreferences sharedPreferences;

  AuthCacheDatasourceImpl({required this.sharedPreferences});

  @override
  Future<Unit> cacheUser(user) {
    final data = user.toJson();
    sharedPreferences.setString(kUserKey, json.encode(data));
    return Future.value(unit);
  }

  @override
  Future<UserModel> getCachedUser() {
    final jsonData = sharedPreferences.getString(kUserKey);
    if (jsonData != null) {
      final data = json.decode(jsonData);
      final user = UserModel.fromJson(data);
      return Future.value(user);
    } else {
      throw EmptyCacheException();
    }
  }

  @override
  Future<Unit> clearUser() {
    final jsonData = sharedPreferences.getString(kUserKey);
    if (jsonData != null) {
      sharedPreferences.remove(kUserKey);
      return Future.value(unit);
    } else {
      throw EmptyCacheException();
    }
  }
}
