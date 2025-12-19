import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/login_controller.dart';
import '../widgets/password_dots.dart';

class PasswordScreen extends StatelessWidget {
  const PasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginController(),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Consumer<LoginController>(
            builder: (context, controller, _) {
              return Column(
                children: [
                  const SizedBox(height: 80),

                  CircleAvatar(
                    radius: 36,
                    backgroundColor: Colors.pink.shade100,
                    child: const Icon(Icons.person, size: 36),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'Hello, Romina!!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),
                  const Text('Type your password'),

                  const SizedBox(height: 24),

                  PasswordDots(
                    length: 6,
                    filled: controller.password.length,
                    error: controller.hasError,
                  ),

                  const SizedBox(height: 16),

                  if (controller.hasError)
                    const Text(
                      'Wrong password',
                      style: TextStyle(color: Colors.red),
                    ),

                  const Spacer(),

                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/password-recovery');
                    },
                    child: const Text('Forgot your password?'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
