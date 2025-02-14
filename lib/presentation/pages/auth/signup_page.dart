import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackit/presentation/blocs/auth/auth_bloc.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    late final TextEditingController emailController;
    late final TextEditingController nameController;
    late final TextEditingController passwordController;

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

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is Authenticated) {
          // TODO: move to home / layout page
        } else if (state is AuthError) {
          await showAdaptiveDialog(
            context: context,
            builder: (context) {
              return Dialog(
                child: Text(state.message),
              );
            },
          );
        }
      },
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              const Text('Sign Up'),
              Form(
                child: Column(
                  children: [
                    TextFormField(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
