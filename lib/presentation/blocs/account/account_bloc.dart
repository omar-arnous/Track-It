import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:trackit/core/errors/failures.dart';
import 'package:trackit/core/strings/failures.dart';
import 'package:trackit/core/strings/messages.dart';
import 'package:trackit/domain/entities/account.dart';
import 'package:trackit/domain/usecases/account/add_account.dart';
import 'package:trackit/domain/usecases/account/delete_account.dart';
import 'package:trackit/domain/usecases/account/edit_account.dart';
import 'package:trackit/domain/usecases/account/get_accounts.dart';
import 'package:trackit/domain/usecases/account/get_selected_account.dart';
import 'package:trackit/domain/usecases/account/set_selected_account.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final GetAccountsUsecase getAccounts;
  final AddAccountUsecase addAccount;
  final EditAccountUsecase editAccount;
  final DeleteAccountUsecase deleteAccount;
  final SetSelectedAccountUsecase setSelectedAccount;
  final GetSelectedAccountUsecase getSelectedAccount;

  AccountBloc({
    required this.getAccounts,
    required this.addAccount,
    required this.editAccount,
    required this.deleteAccount,
    required this.setSelectedAccount,
    required this.getSelectedAccount,
  }) : super(InitialAccountState()) {
    on<AccountEvent>((event, emit) async {
      if (event is GetAccountsEvent) {
        emit(LoadingAccountState());

        final res = await getAccounts();
        final cacheRes = await getSelectedAccount();
        final state = _mapCacheResponseToState(cacheRes);
        if (state is ErrorAccountState) {
          emit(_mapGetResponseToState(res, null));
        } else if (state is LoadedAccountState) {
          emit(_mapGetResponseToState(res, state.selectedAccountId));
        } else {
          emit(_mapGetResponseToState(res, null));
        }
      } else if (event is SelectAccountEvent) {
        emit(LoadingAccountState());

        await setSelectedAccount(event.id);
        final res = await getAccounts();
        emit(_mapGetResponseToState(res, event.id));
      } else if (event is AddAccountEvent) {
        emit(LoadingAccountState());

        final res = await addAccount(event.account);
        emit(_mapResponseToState(res, kSuccessfullAdd));
      } else if (event is UpdateAccountEvent) {
        emit(LoadingAccountState());

        final res = await editAccount(event.account);
        emit(_mapResponseToState(res, kSuccessfullEdit));
      } else if (event is DeleteAccountEvent) {
        emit(LoadingAccountState());

        final res = await deleteAccount(event.id);
        emit(_mapResponseToState(res, kSuccessfullDelete));
      }
    });
  }

  AccountState _mapCacheResponseToState(Either<Failure, Account> cacheRes) {
    return cacheRes.fold(
      (failure) => ErrorAccountState(message: _getMessage(failure)),
      (account) => LoadedAccountState(
        accounts: const [],
        selectedAccountId: account.id!,
      ),
    );
  }

  AccountState _mapGetResponseToState(
      Either<Failure, List<Account>> res, int? id) {
    return res.fold(
      (failure) => ErrorAccountState(message: _getMessage(failure)),
      (accounts) => LoadedAccountState(
        accounts: accounts,
        selectedAccountId: id ?? accounts[0].id!,
      ),
    );
  }

  AccountState _mapResponseToState(Either<Failure, Unit> res, String message) {
    return res.fold(
      (failure) => ErrorAccountState(message: _getMessage(failure)),
      (_) {
        add(GetAccountsEvent());
        return SuccessAccountState(message: message);
      },
    );
  }

  String _getMessage(Failure failure) {
    switch (failure.runtimeType) {
      case EmptyDatabaseFailure:
        return kEmptyDatabaseFailureMessage;
      case DatabaseAddFailure:
        return '$kFailureAdd account';
      case DatabaseEditFailure:
        return '$kFailureEdit account';
      case DatabaseDeleteFailure:
        return '$kFailureDelete account';
      case EmptyCacheFailure:
        return kEmptyCacheFailureMessage;
      default:
        return kGenericFailureMessage;
    }
  }
}
