import 'package:flutter/material.dart';

import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_textfield.dart';
import '../controllers/login_controller.dart';

class LoginForm extends StatelessWidget {
  final LoginController controller;

  const LoginForm({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          label: 'Email',
          controller: controller.emailController,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: 'Password',
          controller: controller.passwordController,
          obscureText: true,
        ),
        const SizedBox(height: 24),
        CustomButton(
          text: 'Login',
          onPressed: () {
            // xử lý login sau
          },
        ),
      ],
    );
  }
}
