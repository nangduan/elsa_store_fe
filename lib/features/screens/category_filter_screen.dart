import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class CategoryFilterScreen extends StatelessWidget {
  const CategoryFilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      'Clothing',
      'Shoes',
      'Bags',
      'Lingerie',
      'Accessories',
      'Watch'
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('All Categories')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: categories
            .map(
              (c) => CheckboxListTile(
            value: false,
            onChanged: (_) {},
            title: Text(c),
          ),
        )
            .toList(),
      ),
    );
  }
}
