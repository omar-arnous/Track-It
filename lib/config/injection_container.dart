import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackit/config/local_service.dart';
import 'package:trackit/data/datasources/auth_cache_datasource.dart';
import 'package:trackit/data/datasources/auth_remote_datasource.dart';
import 'package:trackit/data/datasources/category_local_datasource.dart';
import 'package:trackit/data/repositories/auth_repository_impl.dart';
import 'package:trackit/data/repositories/category_repository_impl.dart';
import 'package:trackit/domain/repositories/auth_repository.dart';
import 'package:trackit/domain/repositories/category_repository.dart';
import 'package:trackit/domain/usecases/category/add_category.dart';
import 'package:trackit/domain/usecases/category/get_categories.dart';
import 'package:trackit/domain/usecases/user/create_user.dart';
import 'package:trackit/domain/usecases/user/login.dart';
import 'package:trackit/domain/usecases/user/logout.dart';
import 'package:trackit/domain/usecases/user/reset_password.dart';
import 'package:trackit/presentation/blocs/auth/auth_bloc.dart';
import 'package:trackit/presentation/blocs/category/category_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      createUser: sl(),
      login: sl(),
      logout: sl(),
      resetPassword: sl(),
    ),
  );

  sl.registerFactory(
    () => CategoryBloc(addCategories: sl(), getCategories: sl()),
  );

  // usecases
  sl.registerLazySingleton(() => LoginUsecase(repository: sl()));
  sl.registerLazySingleton(() => LogoutUsecase(repository: sl()));
  sl.registerLazySingleton(() => CreateUserUsecase(repository: sl()));
  sl.registerLazySingleton(() => ResetPasswordUsecase(repository: sl()));
  sl.registerLazySingleton(() => AddCategoryUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetCategoriesUsecase(repository: sl()));

  // repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDatasource: sl(), cacheDatasource: sl()),
  );
  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(localDatasource: sl()),
  );

  // datasources
  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasourceImpl(firebaseAuth: sl(), firestore: sl()),
  );
  sl.registerLazySingleton<AuthCacheDatasource>(
    () => AuthCacheDatasourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<CategoryLocalDatasource>(
    () => CategoryLocalDatasourceImpl(dbService: sl()),
  );

  // external
  final database = LocalService.instance;
  final sharedPreferences = await SharedPreferences.getInstance();
  final firebaseAuth = FirebaseAuth.instance;
  final fireStore = FirebaseFirestore.instance;

  sl.registerLazySingleton(() => database);
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => firebaseAuth);
  sl.registerLazySingleton(() => fireStore);
}
