import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingTile extends StatelessWidget {
  final String path;
  final String title;
  final IconData? trailing;
  const SettingTile({
    super.key,
    required this.title,
    required this.path,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => context.push(path),
      title: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge,
      ),
      trailing: trailing != null
          ? Icon(trailing)
          : const Icon(Icons.keyboard_arrow_right),
    );
  }
}
