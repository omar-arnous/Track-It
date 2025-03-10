import 'package:flutter/material.dart';
import 'package:trackit/core/constants/colors.dart';

void showSnackMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: Theme.of(context).textTheme.labelMedium,
      ),
      backgroundColor: kBlackColor,
      behavior: SnackBarBehavior.fixed,
      duration: const Duration(seconds: 2),
    ),
  );
}
