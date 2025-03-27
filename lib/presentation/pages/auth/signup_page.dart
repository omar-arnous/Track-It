import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:trackit/core/constants/colors.dart';
import 'package:trackit/core/constants/routes.dart';
import 'package:trackit/presentation/blocs/auth/auth_bloc.dart';
import 'package:trackit/presentation/widgets/form_button.dart';
import 'package:trackit/presentation/widgets/form_input.dart';
import 'package:trackit/presentation/widgets/spinner.dart';

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
  bool isLoading = false;

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
          context.go(kLayoutRoute);
        } else if (state is AuthError) {
          setState(() {
            isLoading = false;
          });
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
                        FormButton(
                          label: 'Sign Up',
                          isLoading: isLoading,
                          onPress: validateForm,
                        ),
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
                              onPressed: () {
                                context.go(kLogInRoute);
                              },
                              child: Text(
                                'Login',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: kPrimaryColor,
                                    ),
                              ),
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

  void validateForm() {
    final isValid = formKey.currentState!.validate();

    if (isValid) {
      setState(() {
        isLoading = true;
      });
      context.read<AuthBloc>().add(
            SignUpEvent(
              email: emailController.text,
              name: nameController.text,
              password: passwordController.text,
            ),
          );
    }
  }
}
