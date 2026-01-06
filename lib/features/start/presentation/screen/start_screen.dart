import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../core/navigation/app_routes.dart';

@RoutePage()
class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),

            CircleAvatar(
              radius: 48,
              backgroundColor: Colors.blue.shade100,
              child: const Icon(
                Icons.shopping_bag,
                size: 48,
                color: Colors.blue,
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Elsa',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Nơi chất lượng được đặt lên hàng đầu',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => context.router.push(const RegisterRoute()),
                child: const Text("Let's get started"),
              ),
            ),

            const SizedBox(height: 16),

            TextButton(
              onPressed: () => context.router.push(const LoginRoute()),
              child: const Text('I already have an account →'),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
