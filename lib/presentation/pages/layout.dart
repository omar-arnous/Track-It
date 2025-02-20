import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:trackit/core/constants/routes.dart';
import 'package:trackit/presentation/blocs/app/app_bloc.dart';
import 'package:trackit/presentation/pages/account/accunts_list.dart';
import 'package:trackit/presentation/pages/category/category_list.dart';
import 'package:trackit/presentation/pages/home_page.dart';
import 'package:trackit/presentation/widgets/empty_page.dart';
import 'package:trackit/presentation/widgets/spinner.dart';

const screens = [
  HomePage(),
  AccountsList(),
  CategoryList(),
  Text('Settings'),
];

class Layout extends StatelessWidget {
  const Layout({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<AppBloc, AppState>(
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
                        icon: Icon(Icons.home_outlined),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.account_balance_outlined),
                        label: 'Accounts',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.layers),
                        label: 'Categories',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.settings),
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
      ),
    );
  }

  AppBar buildAppBar(BuildContext context, int index) {
    switch (index) {
      case 0:
        return AppBar(
          title: const Text(
            'TrackIt',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.add),
            ),
          ],
        );
      case 1:
        return AppBar(
          title: const Text(
            'Accounts',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            IconButton(
              onPressed: () => context.push(kAddEditAccount),
              icon: const Icon(Icons.add),
            ),
          ],
        );
      case 2:
        return AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'Categories',
            style: TextStyle(color: Colors.black),
          ),
        );
      case 3:
        return AppBar(
          title: const Text(
            'Settings',
            style: TextStyle(color: Colors.black),
          ),
        );
      default:
        return AppBar(
          title: const Text(
            'TrackIt',
            style: TextStyle(color: Colors.black),
          ),
        );
    }
  }
}
