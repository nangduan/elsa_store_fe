import 'package:flutter/material.dart';
import 'package:flutter_skeleton/features/screens/variant_bottom_sheet.dart';
import '../auth/presentation/widgets/spec_item.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class ProductDetailFullScreen extends StatelessWidget {
  const ProductDetailFullScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 100),
          children: [
            // Image
            Image.network(
              'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e',
              height: 420,
              width: double.infinity,
              fit: BoxFit.cover,
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price
                  const Text(
                    '\$17.00',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam arcu mauris, scelerisque eu mauris id.',
                  ),

                  const SizedBox(height: 16),

                  // Variations preview
                  Row(
                    children: [
                      const Text(
                        'Variations',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios, size: 16),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(24),
                              ),
                            ),
                            builder: (_) => const VariantBottomSheet(),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  SizedBox(
                    height: 72,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: 3,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (_, __) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e',
                            width: 72,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Specifications
                  const Text(
                    'Specifications',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),
                  const SpecItem(title: 'Material', value: 'Cotton 95%'),
                  const SpecItem(title: 'Origin', value: 'EU'),
                  const SpecItem(title: 'Size guide', value: 'View'),

                  const SizedBox(height: 24),

                  // Delivery
                  const Text(
                    'Delivery',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const DeliveryItem(
                    title: 'Standard',
                    value: '5–7 days',
                    price: '\$3.00',
                  ),
                  const DeliveryItem(
                    title: 'Express',
                    value: '1–2 days',
                    price: '\$12.00',
                  ),

                  const SizedBox(height: 24),

                  // Rating
                  const Text(
                    'Rating & Reviews',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: const [
                      Icon(Icons.star, color: Colors.orange),
                      Icon(Icons.star, color: Colors.orange),
                      Icon(Icons.star, color: Colors.orange),
                      Icon(Icons.star, color: Colors.orange),
                      Icon(Icons.star_half, color: Colors.orange),
                      SizedBox(width: 8),
                      Text('4.5'),
                    ],
                  ),

                  const SizedBox(height: 12),

                  const ReviewItem(
                    name: 'Veronica',
                    comment:
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                  ),

                  const SizedBox(height: 24),

                  // Suggestions
                  const Text(
                    'You Might Like',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // Bottom bar
      bottomNavigationBar: Padding(
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
                child: const Text('Add to cart'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Buy now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
