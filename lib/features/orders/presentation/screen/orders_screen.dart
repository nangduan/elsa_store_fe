import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/api/app_config.dart';
import '../../../../core/constants/format.dart';
import '../../../../core/di/injector.dart';
import '../../data/models/response/order_response.dart';
import '../cubit/order_cubit.dart';

@RoutePage()
class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<OrderCubit>()..load(),
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          title: const Text(
            'Đơn hàng',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
        ),
        body: BlocBuilder<OrderCubit, OrderState>(
          builder: (context, state) {
            if (state.status == OrderStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.black),
              );
            }

            if (state.status == OrderStatus.failure) {
              return RefreshIndicator(
                onRefresh: () => context.read<OrderCubit>().load(),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    const SizedBox(height: 120),
                    Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Colors.red.shade300,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            state.errorMessage ?? 'Không tải được đơn hàng',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          TextButton(
                            onPressed: () => context.read<OrderCubit>().load(),
                            child: const Text('Thử lại'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            final orders = state.orders;
            if (orders.isEmpty) {
              return RefreshIndicator(
                onRefresh: () => context.read<OrderCubit>().load(),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: const [
                    SizedBox(height: 120),
                    Center(
                      child: Text(
                        'Chưa có đơn hàng nào',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => context.read<OrderCubit>().load(),
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                itemCount: orders.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, index) {
                  final order = orders[index];
                  return _OrderCard(order: order);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderResponse order;

  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final code = order.code ?? '-';
    final date = order.orderDate ?? '-';
    final total = Format.formatCurrency(order.finalAmount);
    final status = _statusLabel(order.status);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  code,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            date,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
          const SizedBox(height: 12),
          Column(
            children: order.items.map((item) {
              final imageUrl = _resolveImageUrl(item.pathImage);
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        height: 48,
                        width: 48,
                        color: Colors.grey.shade100,
                        child: imageUrl == null
                            ? const Icon(
                                Icons.image_not_supported_outlined,
                                color: Colors.grey,
                                size: 20,
                              )
                            : Image.network(
                                imageUrl,
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) => const Icon(
                                  Icons.broken_image_outlined,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item.productName ?? '-',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      'x${item.quantity ?? 0}',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      Format.formatCurrency(item.unitPrice),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const Divider(height: 20),
          Row(
            children: [
              const Text(
                'Tổng cộng:',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const Spacer(),
              Text(
                total,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _statusLabel(int? status) {
    switch (status) {
      case 0:
        return 'Mới';
      case 1:
        return 'Đang xử lý';
      case 2:
        return 'Đang giao';
      case 3:
        return 'Hoàn tất';
      case 4:
        return 'Đã hủy';
      default:
        return 'Không rõ';
    }
  }

  String? _resolveImageUrl(String? path) {
    if (path == null || path.isEmpty) return null;
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }
    return "${AppConfig().baseURL}$path";
  }
}
