import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trackit/core/constants/colors.dart';
import 'package:trackit/presentation/widgets/show_snack_message.dart';

Future<void> showDeleteDialog({
  required BuildContext context,
  required Future<void> Function() onConfirm,
  required String label,
  required String title,
  required String content,
  bool? showSnack = false,
  String? snakMessage,
}) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(
              'Cancel',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          TextButton(
            onPressed: () async {
              await onConfirm();
              if (!context.mounted) return;
              context.pop();
              if (showSnack!) {
                showSnackMessage(context, snakMessage!);
              }
            },
            child: Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: kRedColor),
            ),
          ),
        ],
      );
    },
  );
}
