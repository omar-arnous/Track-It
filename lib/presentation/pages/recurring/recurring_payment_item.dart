import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trackit/config/router.dart';
import 'package:trackit/core/constants/colors.dart';
import 'package:trackit/core/constants/routes.dart';
import 'package:trackit/domain/entities/recurring.dart';

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
        borderRadius: BorderRadius.circular(12),
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
      title: const Column(
        children: [],
      ),
    );
  }
}
