import 'package:trackit/data/datasources/app/app_cache_datasource.dart';
import 'package:trackit/domain/repositories/app_repository.dart';

class AppRepositoryImpl implements AppRepository {
  final AppCacheDatasource cacheDatasource;

  AppRepositoryImpl({required this.cacheDatasource});

  @override
  Future<bool> getOnBoardingState() async {
    final onBoardingState = await cacheDatasource.getOnBoardingState();
    return onBoardingState;
  }

  @override
  Future<bool> getTheme() async {
    final isDark = await cacheDatasource.getIsDarkTheme();
    return isDark;
  }

  @override
  Future<void> setOnBoardingState(bool state) async {
    await cacheDatasource.cacheOnBoardingState(state);
  }

  @override
  Future<void> setTheme(bool isDark) async {
    await cacheDatasource.cacheIsDarkTheme(isDark);
  }
}
