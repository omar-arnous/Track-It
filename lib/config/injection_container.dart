import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackit/config/local_service.dart';
import 'package:trackit/core/network/network_info.dart';
import 'package:trackit/data/datasources/account/account_cache_datasource.dart';
import 'package:trackit/data/datasources/account/account_local_datasource.dart';
import 'package:trackit/data/datasources/account/account_remote_datasource.dart';
import 'package:trackit/data/datasources/app/app_cache_datasource.dart';
import 'package:trackit/data/datasources/auth/auth_cache_datasource.dart';
import 'package:trackit/data/datasources/auth/auth_remote_datasource.dart';
import 'package:trackit/data/datasources/budget/budget_local_datasource.dart';
import 'package:trackit/data/datasources/budget/budget_remote_datasource.dart';
import 'package:trackit/data/datasources/category/category_local_datasource.dart';
import 'package:trackit/data/datasources/exchange_rate/exchange_rate_local_data_source.dart';
import 'package:trackit/data/datasources/notification/firebase_messaging_data_source.dart';
import 'package:trackit/data/datasources/recurring/recurring_local_datasource.dart';
import 'package:trackit/data/datasources/recurring/recurring_remote_datasource.dart';
import 'package:trackit/data/datasources/transaction/transaction_local_datasource.dart';
import 'package:trackit/data/datasources/transaction/transaction_remote_datasource.dart';
import 'package:trackit/data/repositories/account_repository_impl.dart';
import 'package:trackit/data/repositories/app_repository_impl.dart';
import 'package:trackit/data/repositories/auth_repository_impl.dart';
import 'package:trackit/data/repositories/budget_repository_impl.dart';
import 'package:trackit/data/repositories/category_repository_impl.dart';
import 'package:trackit/data/repositories/exchange_rate_repository_impl.dart';
import 'package:trackit/data/repositories/notification_repository_impl.dart';
import 'package:trackit/data/repositories/recurring_repository_impl.dart';
import 'package:trackit/data/repositories/transaction_repository_impl.dart';
import 'package:trackit/domain/repositories/account_repository.dart';
import 'package:trackit/domain/repositories/app_repository.dart';
import 'package:trackit/domain/repositories/auth_repository.dart';
import 'package:trackit/domain/repositories/budget_repository.dart';
import 'package:trackit/domain/repositories/category_repository.dart';
import 'package:trackit/domain/repositories/exchange_rate_repository.dart';
import 'package:trackit/domain/repositories/notification_repository.dart';
import 'package:trackit/domain/repositories/recurring_repository.dart';
import 'package:trackit/domain/repositories/transaction_repository.dart';
import 'package:trackit/domain/usecases/account/add_account.dart';
import 'package:trackit/domain/usecases/account/backup_accounts.dart';
import 'package:trackit/domain/usecases/account/decrease_balance.dart';
import 'package:trackit/domain/usecases/account/delete_account.dart';
import 'package:trackit/domain/usecases/account/edit_account.dart';
import 'package:trackit/domain/usecases/account/get_accounts.dart';
import 'package:trackit/domain/usecases/account/get_selected_account.dart';
import 'package:trackit/domain/usecases/account/increasse_balance.dart';
import 'package:trackit/domain/usecases/account/restore_accounts.dart';
import 'package:trackit/domain/usecases/account/reverse_balance.dart';
import 'package:trackit/domain/usecases/account/set_selected_account.dart';
import 'package:trackit/domain/usecases/app/get_onboarding_state.dart';
import 'package:trackit/domain/usecases/app/get_theme.dart';
import 'package:trackit/domain/usecases/app/set_onboarding_state.dart';
import 'package:trackit/domain/usecases/app/set_theme.dart';
import 'package:trackit/domain/usecases/budget/add_budget.dart';
import 'package:trackit/domain/usecases/budget/backup_budget.dart';
import 'package:trackit/domain/usecases/budget/delete_budget.dart';
import 'package:trackit/domain/usecases/budget/get_budget.dart';
import 'package:trackit/domain/usecases/budget/restore_budget.dart';
import 'package:trackit/domain/usecases/budget/update_budget.dart';
import 'package:trackit/domain/usecases/category/add_category.dart';
import 'package:trackit/domain/usecases/category/get_categories.dart';
import 'package:trackit/domain/usecases/exchange_rate/add_exchange_rate.dart';
import 'package:trackit/domain/usecases/exchange_rate/get_exchange_rates.dart';
import 'package:trackit/domain/usecases/exchange_rate/update_exchange_rate.dart';
import 'package:trackit/domain/usecases/notification/get_fcm_token.dart';
import 'package:trackit/domain/usecases/notification/send_notification.dart';
import 'package:trackit/domain/usecases/recurring/add_recuring_payment.dart';
import 'package:trackit/domain/usecases/recurring/backup_recurring_payments.dart';
import 'package:trackit/domain/usecases/recurring/delete_recurring_payment.dart';
import 'package:trackit/domain/usecases/recurring/edit_recurring_payment.dart';
import 'package:trackit/domain/usecases/recurring/get_recurring_payments.dart';
import 'package:trackit/domain/usecases/recurring/restore_recurring_payments.dart';
import 'package:trackit/domain/usecases/transaction/add_transaction.dart';
import 'package:trackit/domain/usecases/transaction/backup_transactions.dart';
import 'package:trackit/domain/usecases/transaction/delete_transaction.dart';
import 'package:trackit/domain/usecases/transaction/get_transactions_by_account_id.dart';
import 'package:trackit/domain/usecases/transaction/restore_transactions.dart';
import 'package:trackit/domain/usecases/transaction/update_transaction.dart';
import 'package:trackit/domain/usecases/user/create_user.dart';
import 'package:trackit/domain/usecases/user/get_authenticated_user.dart';
import 'package:trackit/domain/usecases/user/login.dart';
import 'package:trackit/domain/usecases/user/logout.dart';
import 'package:trackit/domain/usecases/user/reset_password.dart';
import 'package:trackit/presentation/blocs/account/account_bloc.dart';
import 'package:trackit/presentation/blocs/app/app_bloc.dart';
import 'package:trackit/presentation/blocs/auth/auth_bloc.dart';
import 'package:trackit/presentation/blocs/backup/backup_bloc.dart';
import 'package:trackit/presentation/blocs/budget/budget_bloc.dart';
import 'package:trackit/presentation/blocs/category/category_bloc.dart';
import 'package:trackit/presentation/blocs/exchange_rate/exchange_rate_bloc.dart';
import 'package:trackit/presentation/blocs/recurring/reccurring_bloc.dart';
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
      getAuthenticatedUser: sl(),
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
      reverseBalance: sl(),
    ),
  );

  sl.registerFactory(
    () => BudgetBloc(
      getBudget: sl(),
      addBudget: sl(),
      updateBudget: sl(),
      deleteBudget: sl(),
      getFcmToken: sl(),
      sendNotification: sl(),
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

  sl.registerFactory(
    () => BackupBloc(
      backupAccounts: sl(),
      restoreAccounts: sl(),
      backupBudget: sl(),
      restoreBudget: sl(),
      backupTransactions: sl(),
      restoreTransactions: sl(),
      backupRecurringPayments: sl(),
      restoreRecurringPayments: sl(),
    ),
  );

  sl.registerFactory(
    () => ExchangeRateBloc(
      getExchangeRates: sl(),
      addExchangeRate: sl(),
      updateExchangeRate: sl(),
    ),
  );

  sl.registerFactory(
    () => ReccurringBloc(
      getRecurringPayments: sl(),
      addRecurringPayment: sl(),
      editRecurringPayment: sl(),
      deleteRecurringPayment: sl(),
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
  sl.registerLazySingleton(() => GetAuthenticatedUserUsecase(repository: sl()));
  sl.registerLazySingleton(() => ResetPasswordUsecase(repository: sl()));
  sl.registerLazySingleton(() => AddCategoryUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetCategoriesUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetAccountsUsecase(repository: sl()));
  sl.registerLazySingleton(() => AddAccountUsecase(repository: sl()));
  sl.registerLazySingleton(() => EditAccountUsecase(repository: sl()));
  sl.registerLazySingleton(() => DeleteAccountUsecase(repository: sl()));
  sl.registerLazySingleton(() => DecreaseBalanceUsecase(repository: sl()));
  sl.registerLazySingleton(() => IncreaseBalanceUsecase(repository: sl()));
  sl.registerLazySingleton(() => ReverseBalanceUsecase(repository: sl()));
  sl.registerLazySingleton(() => SetSelectedAccountUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetSelectedAccountUsecase(repository: sl()));
  sl.registerLazySingleton(
    () => GetTransactionsByAccountIdUsecase(repository: sl()),
  );
  sl.registerLazySingleton(() => AddTransactionUsecase(repository: sl()));
  sl.registerLazySingleton(() => UpdateTransactionUsecase(repository: sl()));
  sl.registerLazySingleton(() => DeleteTransactionUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetBudgetUsecase(repository: sl()));
  sl.registerLazySingleton(() => AddBudgetUsecase(repository: sl()));
  sl.registerLazySingleton(() => UpdateBudgetUsecase(repository: sl()));
  sl.registerLazySingleton(() => DeleteBudgetUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetFcmTokenUsecase(repository: sl()));
  sl.registerLazySingleton(() => SendNotification(repository: sl()));
  sl.registerLazySingleton(() => BackupAccountsUsecase(repository: sl()));
  sl.registerLazySingleton(() => RestoreAccountsUsecase(repository: sl()));
  sl.registerLazySingleton(() => BackupBudgetUsecase(repository: sl()));
  sl.registerLazySingleton(() => RestoreBudgetUsecase(repository: sl()));
  sl.registerLazySingleton(() => BackupTransactionsUsecase(repository: sl()));
  sl.registerLazySingleton(() => RestoreTransactionsUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetExchangeRatesUsecase(repository: sl()));
  sl.registerLazySingleton(() => AddExchangeRateUsecase(repository: sl()));
  sl.registerLazySingleton(() => UpdateExchangeRateUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetRecurringPaymentsUsecase(repository: sl()));
  sl.registerLazySingleton(() => AddRecurringPaymentsUsecase(repository: sl()));
  sl.registerLazySingleton(
      () => EditRecurringPaymentsUsecase(repository: sl()));
  sl.registerLazySingleton(
      () => DeleteRecurringPaymentsUsecase(repository: sl()));
  sl.registerLazySingleton(
      () => BackupRecurringPaymentsUsecase(repository: sl()));
  sl.registerLazySingleton(
      () => RestoreRecurringPaymentsUsecase(repository: sl()));

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
      remoteDatasource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(
      localDatasource: sl(),
      remoteDatasource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton<BudgetRepository>(
    () => BudgetRepositoryImpl(
      localDatasource: sl(),
      remoteDatasource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton<ExchangeRateRepository>(
    () => ExchangeRateRepositoryImpl(
      localDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<RecurringRepository>(
    () => RecurringRepositoryImpl(
      localDatasource: sl(),
      networkInfo: sl(),
      remoteDatasource: sl(),
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
  sl.registerLazySingleton<TransactionRemoteDatasource>(
    () => TransactionRemoteDatasourceImpl(
      firestore: sl(),
      dbService: sl(),
    ),
  );
  sl.registerLazySingleton<FirebaseMessagingDataSource>(
    () => FirebaseMessagingDataSource(firebaseMessaging: sl()),
  );
  sl.registerLazySingleton<BudgetLocalDatasource>(
    () => BudgetLocalDatasourceImpl(dbService: sl()),
  );
  sl.registerLazySingleton<BudgetRemoteDatasource>(
    () => BudgetRemoteDatasourceImpl(firestore: sl()),
  );
  sl.registerLazySingleton<ExchangeRateLocalDataSource>(
    () => ExchangeRateLocalDataSourceImpl(
      dbService: sl(),
    ),
  );
  sl.registerLazySingleton<RecurringLocalDatasource>(
    () => RecurringLocalDatasourceImpl(
      dbService: sl(),
    ),
  );
  sl.registerLazySingleton<RecurringRemoteDatasource>(
    () => RecurringRemoteDatasourceImpl(
      dbService: sl(),
      firestore: sl(),
    ),
  );

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // external
  final database = LocalService.instance;
  final sharedPreferences = await SharedPreferences.getInstance();
  final firebaseAuth = FirebaseAuth.instance;
  final fireStore = FirebaseFirestore.instance;
  final messaging = FirebaseMessaging.instance;

  sl.registerLazySingleton(() => database);
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => firebaseAuth);
  sl.registerLazySingleton(() => fireStore);
  sl.registerLazySingleton(() => messaging);
  sl.registerLazySingleton(() => InternetConnectionChecker.instance);
}
