import 'package:flutter/material.dart';

class FormButton extends StatelessWidget {
  final String label;
  final void Function() onPress;

  const FormButton({
    super.key,
    required this.label,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPress,
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ),
    );
  }
}
