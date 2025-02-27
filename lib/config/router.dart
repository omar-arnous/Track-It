import 'package:go_router/go_router.dart';
import 'package:trackit/core/constants/routes.dart';
import 'package:trackit/domain/entities/account.dart';
import 'package:trackit/domain/entities/transaction.dart';
import 'package:trackit/presentation/pages/account/account_add_edit_page.dart';
import 'package:trackit/presentation/pages/auth/login_page.dart';
import 'package:trackit/presentation/pages/auth/reset_password_page.dart';
import 'package:trackit/presentation/pages/auth/signup_page.dart';
import 'package:trackit/presentation/pages/category/category_list.dart';
import 'package:trackit/presentation/pages/layout.dart';
import 'package:trackit/presentation/pages/transation/add_edit_transaction.dart';

class AddEditAccountParams {
  final bool isUpdating;
  final Account? account;

  AddEditAccountParams({this.account, this.isUpdating = false});
}

class AddEditTransactionParams {
  final bool isUpdating;
  final Transaction? transaction;

  AddEditTransactionParams({this.transaction, this.isUpdating = false});
}

class Routes {
  final _router = GoRouter(
    // initialLocation: '/spalsh',
    initialLocation: kLayoutRoute,
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
        name: 'Layout',
        path: kLayoutRoute,
        builder: (context, state) => const Layout(),
      ),
      GoRoute(
        name: 'Categories',
        path: kCategoryRoute,
        builder: (context, state) => const CategoryList(),
      ),
      GoRoute(
        name: 'Add Edit account',
        path: kAddEditAccountRoute,
        builder: (context, state) {
          final params = state.extra as AddEditAccountParams?;
          return AccountAddEditPage(
            isUpdateAccount: params?.isUpdating ?? false,
            account: params?.account,
          );
        },
      ),
      GoRoute(
        name: 'Add transaction',
        path: kAddEditTransactionRoute,
        builder: (context, state) {
          final params = state.extra as AddEditTransactionParams?;
          return AddEditTransaction(
            isUpdating: params?.isUpdating ?? false,
            transaction: params?.transaction,
          );
        },
      ),
    ],
  );

  GoRouter get getRouter => _router;
}
