import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_skeleton/core/constants/format.dart';
import 'package:flutter_skeleton/core/navigation/app_routes.dart';

import '../../../../core/api/app_config.dart';
import '../../../../core/di/injector.dart';
import '../cubit/home_cubit.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HomeCubit>()..load(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          automaticallyImplyLeading: false, // Bỏ nút Back
          title: const Text(
            'CỬA HÀNG THỜI TRANG',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
              fontSize: 20,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.notifications_none_rounded,
                color: Colors.black,
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state.status == HomeStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.black),
              );
            }

            if (state.status == HomeStatus.failure) {
              return Center(
                child: Text(state.errorMessage ?? 'Tải dữ liệu thất bại'),
              );
            }

            return RefreshIndicator(
              onRefresh: () async => context.read<HomeCubit>().load(),
              color: Colors.black,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  const SizedBox(height: 10),
                  // Banner Section
                  Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                      image: const DecorationImage(
                        image: NetworkImage(
                          'https://images.unsplash.com/photo-1441986300917-64674bd600d8?q=80&w=1000&auto=format&fit=crop',
                        ), // Placeholder fashion image
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin: Alignment.bottomRight,
                          colors: [
                            Colors.black.withOpacity(0.4),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bộ sưu tập mới',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          Text(
                            'GIẢM GIÁ ĐẾN 50%',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                  _buildSectionTitle('Danh mục'),
                  const SizedBox(height: 16),

                  // Category List
                  SizedBox(
                    height: 45,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.categories.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (_, i) {
                        final item = state.categories[i];
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: i == 0 ? Colors.black : Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade100),
                          ),
                          child: Center(
                            child: Text(
                              item.name ?? '-',
                              style: TextStyle(
                                color: i == 0 ? Colors.white : Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 30),
                  _buildSectionTitle('Hàng mới'),
                  const SizedBox(height: 16),

                  // Product Grid (Thay thế ListTile cũ)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 15,
                          childAspectRatio: 0.7,
                        ),
                    itemCount: state.products.length,
                    itemBuilder: (_, i) {
                      final p = state.products[i];
                      return GestureDetector(
                        onTap: () {
                          context.router.push(
                            ProductDetailFullRoute(product: p),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: _buildProductImage(p.imageUrl),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              p.name ?? '-',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              p.categoryName ?? '-',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              p.basePrice != null
                                  ? Format.formatCurrency(p.basePrice)
                                  : '-',
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductImage(String? imageUrl) {
    final resolved = _resolveImageUrl(imageUrl);
    if (resolved == null) {
      return const Center(
        child: Icon(Icons.shopping_bag_outlined, color: Colors.grey, size: 40),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.network(
        resolved,
        fit: BoxFit.fitWidth,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, __, ___) {
          return const Center(
            child: Icon(
              Icons.shopping_bag_outlined,
              color: Colors.grey,
              size: 40,
            ),
          );
        },
      ),
    );
  }

  String? _resolveImageUrl(String? path) {
    if (path == null || path.isEmpty) {
      return null;
    }

    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }

    final baseUrl = "${AppConfig().baseURL}$path";
    return baseUrl;
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        Text(
          'Xem tất cả',
          style: TextStyle(
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
