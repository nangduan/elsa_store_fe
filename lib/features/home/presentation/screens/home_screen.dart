import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/home_controller.dart';
import '../widgets/product_card.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Text(
                'Banner / Promotion',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'Categories',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          SizedBox(
            height: 80,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, i) => Container(
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(child: Text('Cat ${i + 1}')),
              ),
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemCount: 5,
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'Top Products',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          ...List.generate(
            5,
                (i) => ListTile(
              leading: const Icon(Icons.shopping_bag),
              title: Text('Product ${i + 1}'),
              subtitle: const Text('\$72.00'),
            ),
          ),
        ],
      ),
    );
  }
}
