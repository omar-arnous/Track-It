import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:trackit/domain/entities/budget.dart';

part 'budget_event.dart';
part 'budget_state.dart';

class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  Get

  BudgetBloc() : super(LoadingState()) {
    on<BudgetEvent>((event, emit) async {
      if (event is InitEvent) {
        final res = await 
      } else if (event is GetBudgetsEvent) {

      } else if (event is AddBudgetEvent) {

      } else if (event is UpdateBudgetEvent) {
        
      }else if (event is DeleteBudgetEvent) {

      } else if (event is BudgetNotifyLimitEvent) {

      }
    },);

  }
}
