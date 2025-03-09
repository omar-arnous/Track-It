import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackit/core/constants/routes.dart';
import 'package:trackit/presentation/blocs/backup/backup_bloc.dart';
import 'package:trackit/presentation/pages/settings/setting_action_tile.dart';
import 'package:trackit/presentation/pages/settings/setting_tile.dart';
import 'package:trackit/presentation/pages/settings/user_info.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const UserInfo(),
        const Divider(),
        SettingActionTile(
          title: 'Backup data',
          onPress: () => context.read<BackupBloc>().add(BackupData()),
        ),
        const SettingTile(title: 'My Budgets', path: kBudgetsRoute),
      ],
    );
  }
}
