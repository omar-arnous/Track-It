import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:trackit/core/errors/failures.dart';
import 'package:trackit/core/strings/failures.dart';
import 'package:trackit/core/strings/messages.dart';
import 'package:trackit/domain/entities/budget.dart';
import 'package:trackit/domain/entities/notification.dart';
import 'package:trackit/domain/usecases/budget/add_budget.dart';
import 'package:trackit/domain/usecases/budget/delete_budget.dart';
import 'package:trackit/domain/usecases/budget/get_budget.dart';
import 'package:trackit/domain/usecases/budget/update_budget.dart';
import 'package:trackit/domain/usecases/notification/get_fcm_token.dart';
import 'package:trackit/domain/usecases/notification/send_notification.dart';

part 'budget_event.dart';
part 'budget_state.dart';

class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  final GetBudgetUsecase getBudget;
  final AddBudgetUsecase addBudget;
  final UpdateBudgetUsecase updateBudget;
  final DeleteBudgetUsecase deleteBudget;
  final GetFcmTokenUsecase getFcmToken;
  final SendNotification sendNotification;

  BudgetBloc({
    required this.getBudget,
    required this.addBudget,
    required this.updateBudget,
    required this.deleteBudget,
    required this.getFcmToken,
    required this.sendNotification,
  }) : super(LoadingState()) {
    on<BudgetEvent>(
      (event, emit) async {
        if (event is InitEvent) {
          final res = await getBudget();
          emit(_mapGetResponseToState(res));
        } else if (event is GetBudgetsEvent) {
          final res = await getBudget();
          emit(_mapGetResponseToState(res));
        } else if (event is AddBudgetEvent) {
          final res = await addBudget(event.budget);
          emit(_mapResponseToState(res, "Budget added successfully"));
        } else if (event is UpdateBudgetEvent) {
          final res = await updateBudget(event.budget);
          emit(_mapResponseToState(res, "Budget updated successfully"));
        } else if (event is DeleteBudgetEvent) {
          final res = await deleteBudget(event.id);
          emit(_mapResponseToState(res, "Budget deleted successfully"));
        } else if (event is BudgetNotifyTokenEvent) {
          final token = await getFcmToken();
          add(BudgetNotifyLimitEvent(token: token));
        } else if (event is BudgetNotifyLimitEvent) {
          final notification = Notification(
            title: "Budget Warning",
            body: "Your account expenses has been excedeed your budget",
            token: event.token,
          );
          await sendNotification(notification);
          // emit();
        }
      },
    );
  }

  BudgetState _mapGetResponseToState(Either<Failure, List<Budget>> res) {
    return res.fold(
      (failure) => EmptyState(message: _getMessage(failure)),
      (budgets) {
        for (final budget in budgets) {
          if (budget.endDate == DateTime.now()) {
            add(DeleteBudgetEvent(id: budget.id!));
          }

          if (budget.amountLimit <= budget.account.totalExpenses) {
            add(BudgetNotifyTokenEvent());
          }
        }
        return IdleState(budgets: budgets);
      },
    );
  }

  BudgetState _mapResponseToState(Either<Failure, Unit> res, String message) {
    return res.fold((failure) => ErrorState(message: _getMessage(failure)),
        (_) {
      add(GetBudgetsEvent());
      return SuccessState(message: message);
    });
  }

  String _getMessage(Failure failure) {
    switch (failure.runtimeType) {
      case EmptyDatabaseFailure:
        return 'No Budgets yet';
      case DatabaseAddFailure:
        return '$kFailureAdd budget';
      case DatabaseEditFailure:
        return '$kFailureEdit budget';
      case DatabaseDeleteFailure:
        return '$kFailureDelete budget';
      default:
        return kGenericFailureMessage;
    }
  }
}
