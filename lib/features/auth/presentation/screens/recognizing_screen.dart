import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RecognizingScreen extends StatelessWidget {
  const RecognizingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      context.go('/image-recognized');
    });

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
          const Center(
            child: CircularProgressIndicator(color: Colors.blue),
          ),
        ],
      ),
    );
  }
}
