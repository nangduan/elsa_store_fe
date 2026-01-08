import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../core/navigation/app_routes.dart';

@RoutePage()
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final history = ['Socks', 'Red Dress', 'Sunglasses', 'Mustard Pants'];
    final recommend = ['Skirt', 'Accessories', 'Black T-Shirt', 'White Shoes'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt_outlined),
            onPressed: () => context.router.push(const ImageSearchRoute()),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Search...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
            onSubmitted: (value) {
              context.router.push(const SearchResultRoute());
            },
          ),

          const SizedBox(height: 24),
          const Text('Search history',
              style: TextStyle(fontWeight: FontWeight.bold)),

          Wrap(
            spacing: 8,
            children: history.map((e) => Chip(label: Text(e))).toList(),
          ),

          const SizedBox(height: 24),
          const Text('Recommendations',
              style: TextStyle(fontWeight: FontWeight.bold)),

          Wrap(
            spacing: 8,
            children: recommend.map((e) => Chip(label: Text(e))).toList(),
          ),
        ],
      ),
    );
  }
}
