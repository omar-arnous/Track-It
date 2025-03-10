import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackit/core/constants/routes.dart';
import 'package:trackit/presentation/blocs/app/app_bloc.dart';
import 'package:trackit/presentation/blocs/backup/backup_bloc.dart';
import 'package:trackit/presentation/pages/settings/setting_action_tile.dart';
import 'package:trackit/presentation/pages/settings/setting_tile.dart';
import 'package:trackit/presentation/pages/settings/user_info.dart';
import 'package:trackit/presentation/widgets/spinner.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        if (state is LoadedAppState) {
          final isDark = state.isDark;
          return ListView(
            children: [
              const UserInfo(),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'dark mode',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  Switch(
                    value: isDark,
                    onChanged: (value) => context.read<AppBloc>().add(
                          SetIsDarkTheme(isDark: value),
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const SettingTile(title: 'My Budgets', path: kBudgetsRoute),
              const SizedBox(height: 20),
              const SettingTile(title: 'Exchange Rates', path: kExchangeRates),
              const SizedBox(height: 20),
              SettingActionTile(
                title: 'Backup data',
                onPress: () => context.read<BackupBloc>().add(BackupData()),
              ),
            ],
          );
        } else {
          return const Spinner();
        }
      },
    );
  }
}
