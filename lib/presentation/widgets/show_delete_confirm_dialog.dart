import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trackit/presentation/widgets/show_snack_message.dart';

Future<void> showDeleteDialog(
  BuildContext context,
  Function onConfirm,
  String label,
  String title,
  String content,
  String snakMessage,
) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.pop();
              showSnackMessage(context, snakMessage);
              onConfirm();
            },
            child: Text(
              label,
            ),
          ),
        ],
      );
    },
  );
}
