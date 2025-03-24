import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:trackit/config/router.dart';
import 'package:trackit/core/constants/colors.dart';
import 'package:trackit/core/constants/routes.dart';
import 'package:trackit/core/utils/formatter.dart';
import 'package:trackit/domain/entities/budget.dart';
import 'package:trackit/presentation/blocs/budget/budget_bloc.dart';
import 'package:trackit/presentation/widgets/show_delete_confirm_dialog.dart';

class BudgetItem extends StatelessWidget {
  final Budget budget;
  const BudgetItem({
    super.key,
    required this.budget,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      onTap: () {
        context.push(
          kAddEditBudgetRoute,
          extra: AddEditBudgetParams(
            isUpdating: true,
            budget: budget,
          ),
        );
      },
      contentPadding: const EdgeInsets.all(8),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              "${Formatter.formatBalance(budget.amountLimit)} ${Formatter.formatCurrency(budget.account.currency.name)}",
              style: Theme.of(context).textTheme.bodyLarge),
          Text(budget.account.name,
              style: Theme.of(context).textTheme.bodyMedium),
          Row(
            children: [
              Text(budget.period.name,
                  style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ],
      ),
      trailing: IconButton(
        onPressed: () => showDeleteDialog(
            context: context,
            label: 'delete',
            title: 'Delete ${budget.amountLimit}',
            content: 'Are you sure you want to delete this budget',
            showSnack: true,
            snakMessage: 'budget delete successfully',
            onConfirm: () async {
              context.read<BudgetBloc>().add(
                    DeleteBudgetEvent(id: budget.id!),
                  );
            }),
        icon: const Icon(
          Icons.delete,
          color: kRedColor,
        ),
      ),
    );
  }
}
