import 'package:dartz/dartz.dart';

abstract class AppCacheDatasource {
  Future<bool> getOnBoardingState();
  Future<Unit> cacheOnBoardingState(bool onBoardingState);
  Future<bool> getIsDarkTheme();
  Future<Unit> cacheIsDarkTheme(bool isDark);
}
