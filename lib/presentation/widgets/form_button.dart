import 'package:flutter/material.dart';
import 'package:trackit/presentation/widgets/Spinner.dart';

class FormButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final void Function() onPress;

  const FormButton({
    super.key,
    required this.label,
    required this.isLoading,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: onPress,
        child: isLoading
            ? const Spinner()
            : Text(
                label,
                style: Theme.of(context).textTheme.labelLarge,
              ),
      ),
    );
  }
}
