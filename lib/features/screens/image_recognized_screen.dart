import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ImageRecognizedScreen extends StatelessWidget {
  const ImageRecognizedScreen({super.key});

  @override
  Widget build(BuildContext context) {
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

          Positioned(
            bottom: 60,
            left: 24,
            right: 24,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      'https://images.unsplash.com/photo-1523275335684-37898b6baf30',
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'White Sunglasses',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('\$32.00'),
                      ],
                    ),
                  ),
                  ElevatedButton(onPressed: () {}, child: const Text('Cửa hàng')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
