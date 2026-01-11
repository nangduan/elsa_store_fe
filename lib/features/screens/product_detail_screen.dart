import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class ProductDetailScreen extends StatelessWidget {
  final bool isSale;

  const ProductDetailScreen({super.key, this.isSale = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Image
            Stack(
              children: [
                Image.network(
                  'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e',
                  height: 360,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ListView(
                  children: [
                    Row(
                      children: [
                        Text(
                          '\$24.00',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (isSale) ...[
                          const SizedBox(width: 8),
                          const Text(
                            '\$30.00',
                            style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              '-20%',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 12),
                    const Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam arcu mauris.',
                    ),

                    const SizedBox(height: 16),
                    const Text('Biến thể'),

                    const SizedBox(height: 8),
                    Row(
                      children: ['Pink', 'Red', 'Yellow']
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Chip(label: Text(e)),
                            ),
                          )
                          .toList(),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Bottom actions
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.favorite_border),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Thêm vào giỏ'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Mua ngay'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
