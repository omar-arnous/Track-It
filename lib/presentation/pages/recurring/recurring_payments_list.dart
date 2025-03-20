import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:trackit/core/constants/routes.dart';
import 'package:trackit/presentation/blocs/recurring/reccurring_bloc.dart';
import 'package:trackit/presentation/pages/recurring/recurring_payment_item.dart';
import 'package:trackit/presentation/widgets/no_data.dart';
import 'package:trackit/presentation/widgets/show_error.dart';
import 'package:trackit/presentation/widgets/show_snack_message.dart';
import 'package:trackit/presentation/widgets/spinner.dart';

class RecurringPaymentsList extends StatelessWidget {
  const RecurringPaymentsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recurring Payments'),
        actions: [
          IconButton(
            onPressed: () => context.push(kAddEditRecurringPaymentRoute),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: BlocConsumer<ReccurringBloc, RecurringState>(
          listener: (context, state) {
            if (state is SuccessRecurringState) {
              showSnackMessage(context, state.message);
            }

            if (state is ErrorRecurringState) {
              ShowError.show(context, state.message);
            }
          },
          builder: (context, state) {
            if (state is IdleRecurringState) {
              final recurringPayments = state.recurringPayments;
              return ListView.separated(
                itemCount: recurringPayments.length,
                itemBuilder: (context, index) {
                  return RecurringPaymentItem(
                    recurringPayment: recurringPayments[index],
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 20);
                },
              );
            } else if (state is EmptyRecurringState) {
              return NoData(
                message: state.message,
              );
            } else {
              return const Spinner();
            }
          },
        ),
      ),
    );
  }
}
