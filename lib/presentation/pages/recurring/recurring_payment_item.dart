import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:trackit/config/router.dart';
import 'package:trackit/core/constants/colors.dart';
import 'package:trackit/core/constants/routes.dart';
import 'package:trackit/core/utils/formatter.dart';
import 'package:trackit/domain/entities/recurring.dart';
import 'package:trackit/presentation/blocs/recurring/reccurring_bloc.dart';
import 'package:trackit/presentation/widgets/show_delete_confirm_dialog.dart';

class RecurringPaymentItem extends StatelessWidget {
  final Recurring recurringPayment;
  const RecurringPaymentItem({
    super.key,
    required this.recurringPayment,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      onTap: () {
        context.push(
          kAddEditRecurringPaymentRoute,
          extra: AddEditRecurringPaymentParams(
            isUpdating: true,
            recurringPayment: recurringPayment,
          ),
        );
      },
      contentPadding: const EdgeInsets.all(8),
      leading: CircleAvatar(
        backgroundColor: kWhiteColor,
        child: Icon(
          recurringPayment.category.icon,
          color: recurringPayment.category.color,
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            recurringPayment.account.name,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            recurringPayment.frequency.name,
            style: Theme.of(context).textTheme.labelMedium,
          ),
          Text(
            recurringPayment.note ?? '',
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontStyle: FontStyle.italic,
                ),
          ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '-${Formatter.formatBalance(recurringPayment.amount)} ${Formatter.formatCurrency(recurringPayment.currencyType.name)}',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          Text(
            Formatter.formatDate(recurringPayment.nextDueDate),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
