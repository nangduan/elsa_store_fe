import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../core/navigation/app_routes.dart';

@RoutePage()
class RecognizingScreen extends StatelessWidget {
  const RecognizingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      context.router.replace(const ImageRecognizedRoute());
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Image.network(
            'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          const Center(child: CircularProgressIndicator(color: Colors.blue)),
        ],
      ),
    );
  }
}
