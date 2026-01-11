import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'custom_button.dart';
import 'custom_textfield.dart';
import '../auth/data/models/request/login_request.dart';
import '../auth/presentation/cubit/login/login_cubit.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();

    // emailController.addListener(() {
    //   context.read<LoginCubit>().emailChanged(emailController.text);
    // });
    // passwordController.addListener(() {
    //   context.read<LoginCubit>().passwordChanged(passwordController.text);
    // });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(label: 'Email', controller: emailController),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Mật khẩu',
                controller: passwordController,
                obscureText: true,
              ),
              const SizedBox(height: 8),
              if (state.status == LoginStatus.failure &&
                  state.errorMessage != null)
                Text(
                  state.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 16),
              CustomButton(
                text: 'Đăng nhập',
                onPressed: () {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }
                  context.read<LoginCubit>().login(
                    LoginRequest(
                      username: emailController.text.trim(),
                      password: passwordController.text.trim(),
                    ),
                  );

                  // context.read<LoginCubit>().submit();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
