import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String name;

  const ProductCard({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(name),
      ),
    );
  }
}
