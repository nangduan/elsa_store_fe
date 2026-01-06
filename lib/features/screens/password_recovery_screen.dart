import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class PasswordRecoveryScreen extends StatelessWidget {
  const PasswordRecoveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String method = 'sms';

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 80),

            CircleAvatar(
              radius: 36,
              backgroundColor: Colors.pink.shade100,
              child: const Icon(Icons.person),
            ),

            const SizedBox(height: 16),

            const Text(
              'Password Recovery',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'How would you like to restore your password?',
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            RadioListTile(
              value: 'sms',
              groupValue: method,
              onChanged: (_) {},
              title: const Text('SMS'),
            ),
            RadioListTile(
              value: 'email',
              groupValue: method,
              onChanged: (_) {},
              title: const Text('Email'),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Next'),
              ),
            ),

            const SizedBox(height: 16),

            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
