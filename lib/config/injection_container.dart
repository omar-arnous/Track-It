import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:trackit/config/local_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Bloc

  // usecases

  // repositories

  // datasources

  // external
  final database = LocalService.instance;
  final sharedPreferences = await SharedPreferences.getInstance();

  sl.registerLazySingleton(() => database);
  sl.registerLazySingleton(() => sharedPreferences);
}
