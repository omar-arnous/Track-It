import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackit/core/constants/colors.dart';
import 'package:trackit/presentation/blocs/auth/auth_bloc.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  child: Center(
                    child: Text(
                      state.user.name[0],
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Text(state.user.name),
              ],
            ),
          );
        } else {
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              // TODO: listen for theme and change color based on it
              color: kBlackColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  child: Center(
                    child: Text(
                      "A",
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Text(
                  "Username",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
