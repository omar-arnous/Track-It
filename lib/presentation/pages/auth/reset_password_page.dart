import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackit/presentation/blocs/auth/auth_bloc.dart';
import 'package:trackit/presentation/widgets/form_button.dart';
import 'package:trackit/presentation/widgets/form_input.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reset Password',
                  style: Theme.of(context).textTheme.displayLarge,
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
                      ),
                      const SizedBox(height: 24),
                      FormButton(
                        label: 'Sign Up',
                        isLoading: isLoading,
                        onPress: validateForm,
                      ),
                    ],
                  ),
                ),
              ],
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
      context
          .read<AuthBloc>()
          .add(ResetPasswordEvent(email: emailController.text));
    }
  }
}
