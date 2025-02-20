import 'package:flutter/material.dart';

void showSnackMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.black,
      behavior: SnackBarBehavior.fixed,
      duration: const Duration(seconds: 2),
    ),
  );
}
