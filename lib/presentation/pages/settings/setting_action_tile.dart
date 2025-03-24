import 'package:flutter/material.dart';

class SettingActionTile extends StatelessWidget {
  final void Function() onPress;
  final String title;
  final Widget? trailing;
  const SettingActionTile({
    super.key,
    required this.title,
    required this.onPress,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      title: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge,
      ),
      trailing: trailing,
    );
  }
}
