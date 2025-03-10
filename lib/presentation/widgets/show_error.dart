import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ShowError {
  static Future<void> show(BuildContext context, String message) async {
    return showAdaptiveDialog(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: Text(
          'Something went wrong',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        content: Text(
          message,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(
              'OK',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}
