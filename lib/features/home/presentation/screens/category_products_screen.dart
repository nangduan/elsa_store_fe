import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/home_cubit.dart';
import '../../../../core/api/app_config.dart';
import '../../../../core/constants/format.dart';
import '../../../../core/navigation/app_routes.dart';

@RoutePage()
class CategoryProductsScreen extends StatelessWidget {
  final String title;
  final int? categoryId;
  final List<String> keywords;

  const CategoryProductsScreen({super.key, required this.title, this.categoryId, this.keywords = const []});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state.status == HomeStatus.loading) {
            return const Center(child: CircularProgressIndicator(color: Colors.black));
          }

          final products = state.products;
          final filtered = categoryId != null
              ? products.where((p) => p.categoryId == categoryId).toList()
              : _filterByKeywords(products, keywords);

          if (filtered.isEmpty) {
            return const Center(child: Text('Không có sản phẩm'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filtered.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.65,
            ),
            itemBuilder: (_, i) {
              final p = filtered[i];
              return GestureDetector(
                onTap: () => context.router.push(ProductDetailFullRoute(product: p)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: _buildProductImage(p.imageUrl),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(p.name ?? '-', maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Text(p.basePrice != null ? Format.formatCurrency(p.basePrice) : '-', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  List<dynamic> _filterByKeywords(List products, List<String> keywords) {
    if (keywords.isEmpty) return products;
    final lower = keywords.map((k) => k.toLowerCase()).toList();
    return products.where((p) {
      final name = (p.name ?? '').toString().toLowerCase();
      final category = (p.categoryName ?? '').toString().toLowerCase();
      return lower.any((k) => name.contains(k) || category.contains(k));
    }).toList();
  }

  Widget _buildProductImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return const Center(child: Icon(Icons.shopping_bag_outlined, color: Colors.grey));
    }

    final resolved = imageUrl.startsWith('http') ? imageUrl : "${AppConfig().baseURL}$imageUrl";
    return Image.network(resolved, fit: BoxFit.cover, width: double.infinity, height: double.infinity, errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.shopping_bag_outlined, color: Colors.grey)));
  }
}
