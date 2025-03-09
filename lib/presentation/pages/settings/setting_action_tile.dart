import 'package:flutter/material.dart';

class SettingActionTile extends StatelessWidget {
  final void Function() onPress;
  final String title;
  const SettingActionTile({
    super.key,
    required this.title,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      title: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge,
      ),
    );
  }
}
