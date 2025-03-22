import 'package:go_router/go_router.dart';
import 'package:trackit/core/constants/routes.dart';
import 'package:trackit/domain/entities/account.dart';
import 'package:trackit/domain/entities/budget.dart';
import 'package:trackit/domain/entities/recurring.dart';
import 'package:trackit/domain/entities/transaction.dart';
import 'package:trackit/presentation/pages/account/account_add_edit_page.dart';
import 'package:trackit/presentation/pages/auth/login_page.dart';
import 'package:trackit/presentation/pages/auth/reset_password_page.dart';
import 'package:trackit/presentation/pages/auth/signup_page.dart';
import 'package:trackit/presentation/pages/budget/add_edit_budget.dart';
import 'package:trackit/presentation/pages/budget/budgets_list.dart';
import 'package:trackit/presentation/pages/category/category_list.dart';
import 'package:trackit/presentation/pages/exchange_rate/exchange_rate_list.dart';
import 'package:trackit/presentation/pages/layout.dart';
import 'package:trackit/presentation/pages/recurring/add_edit_recurring_payment.dart';
import 'package:trackit/presentation/pages/recurring/recurring_payments_list.dart';
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

class AddEditBudgetParams {
  final bool isUpdating;
  final Budget? budget;

  AddEditBudgetParams({this.budget, this.isUpdating = false});
}

class AddEditRecurringPaymentParams {
  final bool isUpdating;
  final Recurring? recurringPayment;

  AddEditRecurringPaymentParams(
      {this.recurringPayment, this.isUpdating = false});
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
        name: 'Add Edit transaction',
        path: kAddEditTransactionRoute,
        builder: (context, state) {
          final params = state.extra as AddEditTransactionParams?;
          return AddEditTransaction(
            isUpdating: params?.isUpdating ?? false,
            transaction: params?.transaction,
          );
        },
      ),
      GoRoute(
        name: 'Budgets',
        path: kBudgetsRoute,
        builder: (context, state) => const BudgetsList(),
      ),
      GoRoute(
        name: 'Add Edit Budget',
        path: kAddEditBudgetRoute,
        builder: (context, state) {
          final params = state.extra as AddEditBudgetParams?;
          return AddEditBudget(
            isUpdating: params?.isUpdating ?? false,
            budget: params?.budget,
          );
        },
      ),
      GoRoute(
        name: 'Exchange Rates',
        path: kExchangeRates,
        builder: (context, state) => const ExchangeRateList(),
      ),
      GoRoute(
        name: 'Recurring Payments',
        path: kRecurringPaymentsRoute,
        builder: (context, state) => const RecurringPaymentsList(),
      ),
      GoRoute(
        name: 'Add Edit Recurring Payment',
        path: kAddEditRecurringPaymentRoute,
        builder: (context, state) {
          final params = state.extra as AddEditRecurringPaymentParams?;
          return AddEditRecurringPayment(
            isUpdating: params?.isUpdating ?? false,
            recurringPayment: params?.recurringPayment,
          );
        },
      ),
    ],
  );

  GoRouter get getRouter => _router;
}
