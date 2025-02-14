import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackit/presentation/blocs/auth/auth_bloc.dart';
import 'package:trackit/presentation/widgets/form_button.dart';
import 'package:trackit/presentation/widgets/form_input.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController emailController;
  late TextEditingController nameController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    nameController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is Authenticated) {
          // TODO: move to home / layout page
        } else if (state is AuthError) {
          await showAdaptiveDialog(
            context: context,
            builder: (context) {
              return AlertDialog.adaptive(
                title: const Text('Error'),
                content: Text(state.message),
              );
            },
          );
        }
      },
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Log In',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  Text(
                    "Welcome back",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        FormInput(
                          controller: emailController,
                          label: 'Email Address',
                          type: Type.email,
                          focus: true,
                        ),
                        FormInput(
                          controller: passwordController,
                          label: 'Password',
                          secure: true,
                          type: Type.password,
                        ),
                        const SizedBox(height: 24),
                        FormButton(label: 'Log In', onPress: () {}),
                        const SizedBox(height: 24),
                        // const Row(
                        //   children: [
                        //     Expanded(
                        //       child: Divider(
                        //         color: Colors.black,
                        //         thickness: 1,
                        //         indent: 10,
                        //         endIndent: 10,
                        //       ),
                        //     ),
                        //     Text("OR"),
                        //     Expanded(
                        //       child: Divider(
                        //         color: Colors.black,
                        //         thickness: 1,
                        //         indent: 10,
                        //         endIndent: 10,
                        //       ),
                        //     ),
                        //   ],
                        // )
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account?",
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                            TextButton(
                              // TODO: implement navigating to signup page
                              onPressed: () {},
                              child: const Text('Signup'),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
