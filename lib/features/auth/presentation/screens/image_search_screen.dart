import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ImageSearchScreen extends StatelessWidget {
  const ImageSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Image.asset(
            'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),

          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                  ),
                  onPressed: () => context.go('/recognizing'),
                  child: const Icon(Icons.camera_alt),
                ),
                const SizedBox(height: 12),
                const Text('Camera', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
