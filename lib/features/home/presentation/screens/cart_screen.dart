import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/api/app_config.dart';
import '../../../../core/constants/format.dart';
import '../../../../core/di/injector.dart';
import '../../../cart/data/models/response/cart_item_response.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';

@RoutePage()
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CartCubit>()..load(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Giỏ hàng')),
        body: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            if (state.status == CartStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.black),
              );
            }

            if (state.status == CartStatus.failure) {
              return Center(
                child: Text(state.errorMessage ?? 'Không tải được giỏ hàng'),
              );
            }

            final items = state.cart?.items ?? const [];
            if (items.isEmpty) {
              return const Center(child: Text('Giỏ hàng trống'));
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) {
                      final item = items[i];
                      return _CartItem(
                        item: item,
                        onDecrease: () {
                          final qty = item.quantity ?? 0;
                          if (item.id == null) return;
                          if (qty <= 1) {
                            context.read<CartCubit>().deleteItem(item.id!);
                          } else {
                            context
                                .read<CartCubit>()
                                .updateItemQuantity(item.id!, qty - 1);
                          }
                        },
                        onIncrease: () {
                          final qty = item.quantity ?? 0;
                          if (item.id == null) return;
                          context
                              .read<CartCubit>()
                              .updateItemQuantity(item.id!, qty + 1);
                        },
                      );
                    },
                  ),
                ),
                _buildTotal(state.cart?.totalAmount),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTotal(double? total) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              const Text('Tổng'),
              const Spacer(),
              Text(
                Format.formatCurrency(total ?? 0),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Thanh toán'),
          ),
        ],
      ),
    );
  }
}

class _CartItem extends StatelessWidget {
  final CartItemResponse item;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  const _CartItem({
    required this.item,
    required this.onDecrease,
    required this.onIncrease,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = _resolveImageUrl(item.imageUrl);
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child:
              imageUrl == null
                  ? Container(
                    height: 80,
                    width: 80,
                    color: Colors.grey.shade100,
                    child: const Icon(
                      Icons.image_not_supported_outlined,
                      color: Colors.grey,
                    ),
                  )
                  : Image.network(
                    imageUrl,
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return Container(
                        height: 80,
                        width: 80,
                        color: Colors.grey.shade100,
                        child: const Icon(
                          Icons.image_not_supported_outlined,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.productName ?? '-'),
              const SizedBox(height: 4),
              Text(Format.formatCurrency(item.unitPrice ?? 0)),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: onDecrease,
        ),
        Text('${item.quantity ?? 0}'),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: onIncrease,
        ),
      ],
    );
  }

  String? _resolveImageUrl(String? path) {
    if (path == null || path.isEmpty) return null;
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }
    final baseUrl = AppConfig().baseURL;
    final apiIndex = baseUrl.indexOf('/api');
    final root = apiIndex == -1 ? baseUrl : baseUrl.substring(0, apiIndex);
    return Uri.parse(root).resolve(path).toString();
  }
}
