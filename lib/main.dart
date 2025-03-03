import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackit/core/theme/theme.dart';
import 'package:trackit/presentation/blocs/account/account_bloc.dart';
import 'package:trackit/presentation/blocs/app/app_bloc.dart';
import 'package:trackit/presentation/blocs/auth/auth_bloc.dart';
import 'package:trackit/config/router.dart';
import 'package:trackit/presentation/blocs/budget/budget_bloc.dart';
import 'package:trackit/presentation/blocs/category/category_bloc.dart';
import 'package:trackit/presentation/blocs/transaction/transaction_bloc.dart';
import 'firebase_options.dart';

import 'package:trackit/config/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await di.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final routes = Routes();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<AppBloc>()..add(InitializeAppEvent()),
        ),
        BlocProvider(create: (_) => di.sl<AuthBloc>()),
        BlocProvider(
          create: (_) => di.sl<CategoryBloc>()..add(GetCategoriesEvent()),
        ),
        BlocProvider(
          create: (_) => di.sl<AccountBloc>()..add(GetAccountsEvent()),
        ),
        BlocProvider(create: (_) => di.sl<TransactionBloc>()),
        BlocProvider(create: (_) => di.sl<BudgetBloc>()..add(InitEvent())),
      ],
      child: MaterialApp.router(
        title: 'Track It',
        theme: TrackItTheme.light(),
        routerConfig: routes.getRouter,
      ),
    );
  }
}
