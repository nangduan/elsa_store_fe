import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class RecentlyViewedScreen extends StatelessWidget {
  const RecentlyViewedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đã xem gần đây')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Hôm nay', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _grid(),

          const SizedBox(height: 24),
          const Text(
            'Hôm qua',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _grid(),
        ],
      ),
    );
  }

  Widget _grid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.65,
      ),
      itemBuilder: (_, __) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text('Nội dung mẫu'),
            const Text(
              '\$17.00',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        );
      },
    );
  }
}
