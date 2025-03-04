import 'package:flutter/material.dart';
import 'package:trackit/core/constants/routes.dart';
import 'package:trackit/presentation/pages/settings/setting_tile.dart';
import 'package:trackit/presentation/pages/settings/user_info.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        UserInfo(),
        Divider(),
        SettingTile(title: 'My Budgets', path: kBudgetsRoute),
      ],
    );
  }
}
