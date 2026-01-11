import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class WishlistScreen extends StatelessWidget {
  final bool isEmpty;

  const WishlistScreen({super.key, this.isEmpty = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Danh sách yêu thích')),
      body: isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.favorite_border, size: 64),
                  SizedBox(height: 12),
                  Text('Danh sách yêu thích trống'),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: 4,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, __) {
                return _WishlistItem();
              },
            ),
    );
  }
}

class _WishlistItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e',
            height: 80,
            width: 80,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nội dung mẫu'),
              Text('\$32.00', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        IconButton(icon: const Icon(Icons.add_shopping_cart), onPressed: () {}),
      ],
    );
  }
}
