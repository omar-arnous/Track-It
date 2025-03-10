import 'package:flutter/material.dart';
import 'package:trackit/core/constants/colors.dart';

class Spinner extends StatelessWidget {
  const Spinner({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: kPrimaryColor,
      ),
    );
  }
}
