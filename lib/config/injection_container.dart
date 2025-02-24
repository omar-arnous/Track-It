import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackit/config/local_service.dart';
import 'package:trackit/data/datasources/account/account_cache_datasource.dart';
import 'package:trackit/data/datasources/account/account_local_datasource.dart';
import 'package:trackit/data/datasources/account/account_remote_datasource.dart';
import 'package:trackit/data/datasources/app/app_cache_datasource.dart';
import 'package:trackit/data/datasources/auth/auth_cache_datasource.dart';
import 'package:trackit/data/datasources/auth/auth_remote_datasource.dart';
import 'package:trackit/data/datasources/category/category_local_datasource.dart';
import 'package:trackit/data/datasources/transaction/transaction_local_datasource.dart';
import 'package:trackit/data/repositories/account_repository_impl.dart';
import 'package:trackit/data/repositories/app_repository_impl.dart';
import 'package:trackit/data/repositories/auth_repository_impl.dart';
import 'package:trackit/data/repositories/category_repository_impl.dart';
import 'package:trackit/data/repositories/transaction_repository_impl.dart';
import 'package:trackit/domain/repositories/account_repository.dart';
import 'package:trackit/domain/repositories/app_repository.dart';
import 'package:trackit/domain/repositories/auth_repository.dart';
import 'package:trackit/domain/repositories/category_repository.dart';
import 'package:trackit/domain/repositories/transaction_repository.dart';
import 'package:trackit/domain/usecases/account/add_account.dart';
import 'package:trackit/domain/usecases/account/decrease_balance.dart';
import 'package:trackit/domain/usecases/account/delete_account.dart';
import 'package:trackit/domain/usecases/account/edit_account.dart';
import 'package:trackit/domain/usecases/account/get_accounts.dart';
import 'package:trackit/domain/usecases/account/get_selected_account.dart';
import 'package:trackit/domain/usecases/account/increasse_balance.dart';
import 'package:trackit/domain/usecases/account/set_selected_account.dart';
import 'package:trackit/domain/usecases/app/get_onboarding_state.dart';
import 'package:trackit/domain/usecases/app/get_theme.dart';
import 'package:trackit/domain/usecases/app/set_onboarding_state.dart';
import 'package:trackit/domain/usecases/app/set_theme.dart';
import 'package:trackit/domain/usecases/category/add_category.dart';
import 'package:trackit/domain/usecases/category/get_categories.dart';
import 'package:trackit/domain/usecases/transaction/add_transaction.dart';
import 'package:trackit/domain/usecases/transaction/delete_transaction.dart';
import 'package:trackit/domain/usecases/transaction/get_transactions_by_account_id.dart';
import 'package:trackit/domain/usecases/transaction/update_transaction.dart';
import 'package:trackit/domain/usecases/user/create_user.dart';
import 'package:trackit/domain/usecases/user/login.dart';
import 'package:trackit/domain/usecases/user/logout.dart';
import 'package:trackit/domain/usecases/user/reset_password.dart';
import 'package:trackit/presentation/blocs/account/account_bloc.dart';
import 'package:trackit/presentation/blocs/app/app_bloc.dart';
import 'package:trackit/presentation/blocs/auth/auth_bloc.dart';
import 'package:trackit/presentation/blocs/category/category_bloc.dart';
import 'package:trackit/presentation/blocs/transaction/transaction_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Bloc
  sl.registerFactory(
    () => AppBloc(
      setOnboardingState: sl(),
      getOnboardingState: sl(),
      setTheme: sl(),
      getTheme: sl(),
    ),
  );
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

  sl.registerFactory(
    () => AccountBloc(
      getAccounts: sl(),
      addAccount: sl(),
      editAccount: sl(),
      deleteAccount: sl(),
      setSelectedAccount: sl(),
      getSelectedAccount: sl(),
      decreaseBalance: sl(),
      increaseBalance: sl(),
    ),
  );

  sl.registerFactory(
    () => TransactionBloc(
      getTransactionsByAccountId: sl(),
      addTransaction: sl(),
      updateTransaction: sl(),
      deleteTransaction: sl(),
    ),
  );

  // usecases
  sl.registerLazySingleton(() => SetOnboardingStateUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetOnboardingStateUsecase(repository: sl()));
  sl.registerLazySingleton(() => SetThemeUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetThemeUsecase(repository: sl()));
  sl.registerLazySingleton(() => LoginUsecase(repository: sl()));
  sl.registerLazySingleton(() => LogoutUsecase(repository: sl()));
  sl.registerLazySingleton(() => CreateUserUsecase(repository: sl()));
  sl.registerLazySingleton(() => ResetPasswordUsecase(repository: sl()));
  sl.registerLazySingleton(() => AddCategoryUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetCategoriesUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetAccountsUsecase(repository: sl()));
  sl.registerLazySingleton(() => AddAccountUsecase(repository: sl()));
  sl.registerLazySingleton(() => EditAccountUsecase(repository: sl()));
  sl.registerLazySingleton(() => DeleteAccountUsecase(repository: sl()));
  sl.registerLazySingleton(() => DecreaseBalanceUsecase(repository: sl()));
  sl.registerLazySingleton(() => IncreaseBalanceUsecase(repository: sl()));
  sl.registerLazySingleton(() => SetSelectedAccountUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetSelectedAccountUsecase(repository: sl()));
  sl.registerLazySingleton(
    () => GetTransactionsByAccountIdUsecase(repository: sl()),
  );
  sl.registerLazySingleton(() => AddTransactionUsecase(repository: sl()));
  sl.registerLazySingleton(() => UpdateTransactionUsecase(repository: sl()));
  sl.registerLazySingleton(() => DeleteTransactionUsecase(repository: sl()));

  // repositories
  sl.registerLazySingleton<AppRepository>(
    () => AppRepositoryImpl(cacheDatasource: sl()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDatasource: sl(), cacheDatasource: sl()),
  );
  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(localDatasource: sl()),
  );
  sl.registerLazySingleton<AccountRepository>(
    () => AccountRepositoryImpl(
      localDatasource: sl(),
      cacheDatasource: sl(),
    ),
  );
  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(
      localDatasource: sl(),
    ),
  );

  // datasources
  sl.registerLazySingleton<AppCacheDatasource>(
    () => AppCacheDatasourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasourceImpl(firebaseAuth: sl(), firestore: sl()),
  );
  sl.registerLazySingleton<AuthCacheDatasource>(
    () => AuthCacheDatasourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<CategoryLocalDatasource>(
    () => CategoryLocalDatasourceImpl(dbService: sl()),
  );
  sl.registerLazySingleton<AccountLocalDatasource>(
    () => AccountLocalDatasourceImpl(dbService: sl()),
  );
  sl.registerLazySingleton<AccountRemoteDatasource>(
    () => AccountRemoteDatasourceImpl(firestore: sl()),
  );

  sl.registerLazySingleton<AccountCacheDatasource>(
    () => AccountCacheDatasourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<TransactionLocalDatasource>(
    () => TransactionLocalDatasourceImpl(dbService: sl()),
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
