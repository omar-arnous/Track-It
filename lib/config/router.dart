import 'package:go_router/go_router.dart';
import 'package:trackit/core/constants/routes.dart';
import 'package:trackit/presentation/pages/auth/login_page.dart';
import 'package:trackit/presentation/pages/auth/reset_password_page.dart';
import 'package:trackit/presentation/pages/auth/signup_page.dart';
import 'package:trackit/presentation/pages/home_page.dart';

class Routes {
  final _router = GoRouter(
    // initialLocation: '/spalsh',
    initialLocation: kSignUpRoute,
    routes: [
      GoRoute(
        name: 'Sign Up',
        path: kSignUpRoute,
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(
        name: 'Log In',
        path: kLogInRoute,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        name: 'Reset Password',
        path: kResetPasswordRoute,
        builder: (context, state) => const ResetPasswordPage(),
      ),
      GoRoute(
        name: 'Home',
        path: kHomeRoute,
        builder: (context, state) => const HomePage(),
      ),
    ],
  );

  GoRouter get getRouter => _router;
}
