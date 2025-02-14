import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackit/presentation/blocs/auth/auth_bloc.dart';
import 'package:trackit/presentation/widgets/form_button.dart';
import 'package:trackit/presentation/widgets/form_input.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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
                    'Sign Up',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  Text(
                    "Let's create a new account",
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
                          controller: nameController,
                          label: 'User Name',
                          require: true,
                        ),
                        FormInput(
                          controller: passwordController,
                          label: 'Password',
                          secure: true,
                          type: Type.password,
                        ),
                        const SizedBox(height: 24),
                        FormButton(label: 'Sign Up', onPress: () {}),
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
                              "Already have an account?",
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                            TextButton(
                              // TODO: implement navigating to login page
                              onPressed: () {},
                              child: const Text('Login'),
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
