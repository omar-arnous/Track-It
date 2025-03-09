import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:trackit/core/constants/routes.dart';
import 'package:trackit/presentation/blocs/budget/budget_bloc.dart';
import 'package:trackit/presentation/pages/budget/budget_item.dart';
import 'package:trackit/presentation/widgets/no_data.dart';
import 'package:trackit/presentation/widgets/show_error.dart';
import 'package:trackit/presentation/widgets/show_snack_message.dart';
import 'package:trackit/presentation/widgets/spinner.dart';

class BudgetsList extends StatelessWidget {
  const BudgetsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budgets'),
        actions: [
          IconButton(
            onPressed: () => context.push(kAddEditBudgetRoute),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: BlocConsumer<BudgetBloc, BudgetState>(
          listener: (context, state) {
            if (state is SuccessState) {
              showSnackMessage(context, state.message);
            }

            if (state is ErrorState) {
              ShowError.show(context, state.message);
            }
          },
          builder: (context, state) {
            if (state is IdleState) {
              final budgets = state.budgets;
              return ListView.separated(
                itemCount: budgets.length,
                itemBuilder: (context, index) {
                  return BudgetItem(
                    budget: budgets[index],
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 20);
                },
              );
            } else if (state is EmptyState) {
              return NoData(message: state.message);
            } else {
              return const Spinner();
            }
          },
        ),
      ),
    );
  }
}
