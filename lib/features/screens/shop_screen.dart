import 'package:flutter/material.dart';
import '../auth/presentation/widgets/section_header.dart';
import '../auth/presentation/widgets/category_grid.dart';
import '../auth/presentation/widgets/product_list.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Search
            TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Big Sale
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                'https://images.unsplash.com/photo-1542291026-7eec264c27ff',
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 24),

            SectionHeader(title: 'Categories'),
            CategoryGrid(),

            const SizedBox(height: 24),

            SectionHeader(title: 'Top Products'),
            ProductList(),

            const SizedBox(height: 24),

            SectionHeader(title: 'New Items'),
            ProductList(),

            const SizedBox(height: 24),

            SectionHeader(title: 'Flash Sale'),
            ProductList(),

            const SizedBox(height: 24),

            SectionHeader(title: 'Most Popular'),
            ProductList(),

            const SizedBox(height: 24),

            SectionHeader(title: 'Just For You'),
            ProductList(),
          ],
        ),
      ),
    );
  }
}
