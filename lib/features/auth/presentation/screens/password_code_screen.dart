import 'package:flutter/material.dart';

class PasswordCodeScreen extends StatelessWidget {
  const PasswordCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            const Text(
              'Enter 4-digits code we sent you\non your phone number',
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),
            const Text('+98*******00'),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                4,
                    (_) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/new-password');
                },
                child: const Text('Send Again'),
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
