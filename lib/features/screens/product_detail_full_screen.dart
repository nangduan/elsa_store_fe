import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../home/data/models/response/product_response.dart';
import '../product/presentation/cubit/product_variant_cubit.dart';
import '../../core/di/injector.dart';

@RoutePage()
class ProductDetailFullScreen extends StatelessWidget {
  const ProductDetailFullScreen({super.key, required this.product});

  final ProductResponse product;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProductVariantCubit>()..load(product.id),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 450,
              pinned: true,
              leading: IconButton(
                icon: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    size: 18,
                    color: Colors.black,
                  ),
                ),
                onPressed: () => context.router.pop(),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Image.network(
                  'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          product.categoryName?.toUpperCase() ?? 'FASHION',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          '${product.basePrice?.toStringAsFixed(0) ?? '0'} Ž`',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Product Name
                    Text(
                      product.name ?? 'Product Name',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Description
                    Text(
                      product.description ??
                          'No description available for this product.',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        height: 1.5,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildSectionTitle('Variations'),
                    const SizedBox(height: 12),
                    _buildVariationsList(),
                    const SizedBox(height: 32),
                    _buildSectionTitle('Specifications'),
                    const SizedBox(height: 12),
                    _buildSpecItem('Material', 'Cotton 95%'),
                    _buildSpecItem('Origin', 'Vietnam'),
                    _buildSpecItem('Style', 'Modern Fit'),
                    const SizedBox(height: 32),
                    _buildSectionTitle('Delivery'),
                    const SizedBox(height: 12),
                    _buildDeliveryOption('Standard', '5ƒ?"7 days', 'Free'),
                    _buildDeliveryOption('Express', '1ƒ?"2 days', '30.000 Ž`'),
                    const SizedBox(
                      height: 100,
                    ), // Kho §œng tr ¯`ng cu ¯`i Ž` ¯Ÿ khA'ng b ¯< Ž`A" b ¯Yi bottom bar
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomSheet: _buildBottomAction(context),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildSpecItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: Colors.grey.shade500)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildVariationsList() {
    return BlocBuilder<ProductVariantCubit, ProductVariantState>(
      builder: (context, state) {
        if (state.status.isLoading) {
          return const SizedBox(
            height: 80,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.status.isFailure) {
          return SizedBox(
            height: 80,
            child: Center(
              child: Text(state.errorMessage ?? 'Failed to load variants'),
            ),
          );
        }

        if (state.variants.isEmpty) {
          return const SizedBox(
            height: 80,
            child: Center(child: Text('No variants available')),
          );
        }

        return SizedBox(
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: state.variants.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, i) {
              final variant = state.variants[i];
              final color = variant.color ?? '-';
              final size = variant.size ?? '-';
              return Container(
                width: 120,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade100,
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$color / $size',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      variant.price != null ? '${variant.price} Ž`' : '-',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildDeliveryOption(String title, String time, String price) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_shipping_outlined, size: 20),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(
                time,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
            ],
          ),
          const Spacer(),
          Text(price, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildBottomAction(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.favorite_border),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SizedBox(
              height: 54,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                onPressed: () {},
                child: const Text(
                  'ADD TO CART',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
