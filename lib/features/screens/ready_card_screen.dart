import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../core/navigation/app_routes.dart';

@RoutePage()
class ReadyCardScreen extends StatelessWidget {
  const ReadyCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Column(
        children: [
          const SizedBox(height: 60),

          Expanded(
            child: Container(
              margin: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Image
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                    child: Image.network(
                      'https://images.unsplash.com/photo-1503342217505-b0a15ec3261c',
                      height: 240,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.fromLTRB(24, 32, 24, 16),
                    child: Column(
                      children: [
                        Text(
                          'Ready?',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit.',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                    child: SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          context.router.replace(const MainBottomNavRoute());
                        },
                        child: const Text('Continue'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Indicator dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              4,
              (index) => Container(
                margin: const EdgeInsets.all(4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: index == 3 ? Colors.blue : Colors.blue.shade200,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
