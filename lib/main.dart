import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackit/core/theme/theme.dart';
import 'package:trackit/presentation/blocs/auth/auth_bloc.dart';
import 'package:trackit/presentation/pages/auth/login_page.dart';
import 'package:trackit/presentation/pages/auth/signup_page.dart';
import 'firebase_options.dart';

import 'package:trackit/config/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => di.sl<AuthBloc>())],
      child: MaterialApp(
        title: 'Track It',
        theme: TrackItTheme.light(),
        home: const LoginPage(),
      ),
    );
  }
}
