import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackit/presentation/blocs/app/app_bloc.dart';
import 'package:trackit/presentation/pages/home_page.dart';
import 'package:trackit/presentation/widgets/show_error.dart';
import 'package:trackit/presentation/widgets/spinner.dart';

const screens = [
  HomePage(),
  Text('Accounts'),
  Text('Categories'),
  Text('Settings'),
];

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(),
        body: BlocBuilder<AppBloc, AppState>(
          builder: (context, state) {
            if (state is LoadingAppState) {
              return const Spinner();
            } else if (state is LoadedAppState) {
              return screens[state.selectedIndex];
            } else {
              if (context.mounted) {
                Future.microtask(
                  () => ShowError.show(
                    context,
                    "Unable to load the app, Please try again",
                  ),
                );
                throw Error();
              } else {
                throw Error();
              }
            }
          },
        ),
        bottomNavigationBar: BlocListener<AppBloc, AppState>(
          listener: (context, state) {
            if (state is LoadedAppState) {
              setState(() {
                selectedIndex = state.selectedIndex;
              });
            }
          },
          child: Container(
            margin: const EdgeInsets.all(15),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: BottomNavigationBar(
                currentIndex: selectedIndex,
                onTap: (index) => {
                  context.read<AppBloc>().add(
                        SetSelectedIndexEvent(
                          selectedIndex: index,
                        ),
                      ),
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
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    switch (selectedIndex) {
      case 0:
        return AppBar(
          title: const Text('TrackIt'),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.add),
            ),
          ],
        );
      case 1:
        return AppBar(
          title: const Text('Accounts'),
          actions: [
            IconButton(
              onPressed: () {},
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
