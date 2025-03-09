import 'package:flutter/material.dart';
import 'package:trackit/core/constants/colors.dart';

void showSnackMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: kBlackColor,
      behavior: SnackBarBehavior.fixed,
      duration: const Duration(seconds: 2),
    ),
  );
}
