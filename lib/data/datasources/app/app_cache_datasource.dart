import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackit/core/constants/cache_constants.dart';

abstract class AppCacheDatasource {
  Future<bool> getOnBoardingState();
  Future<void> cacheOnBoardingState(bool onBoardingState);
  Future<bool> getIsDarkTheme();
  Future<void> cacheIsDarkTheme(bool isDark);
}

class AppCacheDatasourceImpl implements AppCacheDatasource {
  final SharedPreferences sharedPreferences;

  AppCacheDatasourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheIsDarkTheme(bool isDark) {
    sharedPreferences.setBool(kThemeKey, isDark);
    return Future.value();
  }

  @override
  Future<void> cacheOnBoardingState(bool onBoardingState) {
    sharedPreferences.setBool(kOnBoardingStateKey, onBoardingState);
    return Future.value();
  }

  @override
  Future<bool> getIsDarkTheme() {
    final res = sharedPreferences.getBool(kThemeKey);
    return Future.value(res);
  }

  @override
  Future<bool> getOnBoardingState() {
    final res = sharedPreferences.getBool(kOnBoardingStateKey);
    return Future.value(res);
  }
}
