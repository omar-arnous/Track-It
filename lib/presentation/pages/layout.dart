import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:trackit/core/constants/routes.dart';
import 'package:trackit/presentation/blocs/app/app_bloc.dart';
import 'package:trackit/presentation/pages/account/accunts_list.dart';
import 'package:trackit/presentation/pages/category/category_list.dart';
import 'package:trackit/presentation/pages/home_page.dart';
import 'package:trackit/presentation/pages/settings/settings_page.dart';
import 'package:trackit/presentation/widgets/empty_page.dart';
import 'package:trackit/presentation/widgets/spinner.dart';

const screens = [
  HomePage(),
  AccountsList(),
  CategoryList(),
  SettingsPage(),
];

class Layout extends StatelessWidget {
  const Layout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        if (state is LoadingAppState) {
          return const Scaffold(body: Spinner());
        } else if (state is LoadedAppState) {
          return Scaffold(
            appBar: buildAppBar(context, state.selectedIndex),
            body: Padding(
              padding: const EdgeInsets.all(15),
              child: screens[state.selectedIndex],
            ),
            bottomNavigationBar: Container(
              margin: const EdgeInsets.all(15),
              height: 80,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: BottomNavigationBar(
                  currentIndex: state.selectedIndex,
                  onTap: (index) {
                    context.read<AppBloc>().add(
                          SetSelectedIndexEvent(
                            selectedIndex: index,
                          ),
                        );
                  },
                  items: const [
                    BottomNavigationBarItem(
                      // icon: Icon(Icons.home_outlined),
                      icon: FaIcon(
                        FontAwesomeIcons.house,
                        size: 20.0,
                      ),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      // icon: Icon(Icons.account_balance_outlined),
                      icon: FaIcon(
                        FontAwesomeIcons.buildingColumns,
                        size: 20.0,
                      ),
                      label: 'Accounts',
                    ),
                    BottomNavigationBarItem(
                      // icon: Icon(Icons.layers),
                      icon: FaIcon(
                        FontAwesomeIcons.layerGroup,
                        size: 20.0,
                      ),
                      label: 'Categories',
                    ),
                    BottomNavigationBarItem(
                      // icon: Icon(Icons.settings),
                      icon: FaIcon(
                        FontAwesomeIcons.gear,
                        size: 20.0,
                      ),
                      label: 'Settings',
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const EmptyPage();
        }
      },
    );
  }

  AppBar buildAppBar(BuildContext context, int index) {
    switch (index) {
      case 0:
        return AppBar(
          title: const Text('TrackIt'),
          actions: [
            IconButton(
              onPressed: () => context.push(kAddEditTransactionRoute),
              icon: const Icon(Icons.add),
            ),
          ],
        );
      case 1:
        return AppBar(
          title: const Text('Accounts'),
          actions: [
            IconButton(
              onPressed: () => context.push(kAddEditAccountRoute),
              icon: const Icon(Icons.add),
            ),
          ],
        );
      case 2:
        return AppBar(
          title: const Text('Categories'),
        );
      case 3:
        return AppBar(
          title: const Text('Settings'),
        );
      default:
        return AppBar(
          title: const Text('TrackIt'),
        );
    }
  }
}
