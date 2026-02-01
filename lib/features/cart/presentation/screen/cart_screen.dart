import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_skeleton/core/di/injector.dart';
import 'package:flutter_skeleton/core/storage/flutter_store_core.dart';
import 'package:flutter_skeleton/features/orders/domain/usecases/create_order_use_case.dart';
import 'package:flutter_skeleton/features/orders/presentation/cubit/order_cubit.dart';

import '../../../../core/api/app_config.dart';
import '../../../../core/constants/format.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../../orders/data/models/request/create_order_item_request.dart';
import '../../data/models/response/cart_item_response.dart';
import '../cubit/cart_cubit.dart';

@RoutePage()
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Giỏ hàng',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state.status == CartStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.black),
            );
          }

          if (state.status == CartStatus.failure) {
            Future<void> onRetry() => context.read<CartCubit>().load();
            return RefreshIndicator(
              onRefresh: onRetry,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: 120),
                  _buildErrorState(state.errorMessage, onRetry),
                ],
              ),
            );
          }

          final items = state.cart?.items ?? const [];

          if (items.isEmpty) {
            return RefreshIndicator(
              onRefresh: () => context.read<CartCubit>().load(),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: 80),
                  _buildEmptyState(context),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => context.read<CartCubit>().load(),
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (_, i) {
                      final item = items[i];
                      return _CartItemCard(
                        item: item,
                        onDecrease: () {
                          final qty = item.quantity ?? 0;
                          if (item.id == null) return;
                          if (qty <= 1) {
                            _confirmDelete(context, item);
                          } else {
                            context.read<CartCubit>().updateItemQuantity(
                              item.id!,
                              qty - 1,
                            );
                          }
                        },
                        onIncrease: () {
                          final qty = item.quantity ?? 0;
                          if (item.id == null) return;
                          context.read<CartCubit>().updateItemQuantity(
                            item.id!,
                            qty + 1,
                          );
                        },
                        onDelete: () {
                          if (item.id != null) {
                            context.read<CartCubit>().deleteItem(item.id!);
                          }
                        },
                        onCheckout: () => _checkoutItem(context, item),
                      );
                    },
                  ),
                ),
              ),
              _buildBottomCheckout(context, state.cart?.totalAmount, items),
            ],
          );
        },
      ),
    );
  }

  Widget _buildErrorState(String? message, Future<void> Function() onRetry) {
    return Column(
      children: [
        Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
        const SizedBox(height: 16),
        Text(
          message ?? 'Không tải được giỏ hàng',
          style: const TextStyle(color: Colors.grey),
        ),
        TextButton(onPressed: () => onRetry(), child: const Text('Thử lại')),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.shopping_cart_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Giỏ hàng của bạn đang trống',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        const Text(
          'Hãy thêm vài món đồ sành điệu vào nhé!',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {},
          child: const Text('Tiếp tục mua sắm'),
        ),
      ],
    );
  }

  void _confirmDelete(BuildContext context, CartItemResponse item) {
    if (item.id == null) return;
    context.read<CartCubit>().deleteItem(item.id!);
  }

  Future<void> _checkoutItem(
    BuildContext context,
    CartItemResponse item,
  ) async {
    final variantId = item.productVariantId;
    final amount =
        item.lineTotal ??
        (item.unitPrice != null && item.quantity != null
            ? item.unitPrice! * item.quantity!
            : null);
    if (variantId == null || amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dữ liệu sản phẩm không hợp lệ')),
      );
      return;
    }

    final userId = await FlutterStoreCore.readUserId();
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thiếu thông tin người dùng')),
      );
      return;
    }
    await getIt<CreateOrderUseCase>()
        .call(userId, [
          CreateOrderItemRequest(
            productVariantId: variantId,
            quantity: item.quantity ?? 1,
          ),
        ])
        .then((value) {
          if (value != null) {
            context.router.push(
              PaymentRoute(
                productName: item.productName ?? 'San pham',
                imageUrl: item.imageUrl,
                amount: amount,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Tạo đơn hàng thất bại')),
            );
          }
        });
  }

  Widget _buildBottomCheckout(
    BuildContext context,
    double? total,
    List<CartItemResponse> items,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -4),
            blurRadius: 16,
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Text(
                  'Tổng cộng:',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
                const Spacer(),
                Text(
                  Format.formatCurrency(total),
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => _checkoutAll(context, items),
                child: const Text(
                  'THANH TOÁN',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _checkoutAll(
    BuildContext context,
    List<CartItemResponse> items,
  ) async {
    final total = items.fold<double>(
      0,
      (sum, item) => sum + (item.lineTotal ?? 0),
    );

    if (total <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gio hang dang trong')));
      return;
    }

    List<CreateOrderItemRequest> orderItems = items.map((item) {
      return CreateOrderItemRequest(
        productVariantId: item.productVariantId!,
        quantity: item.quantity!,
      );
    }).toList();

    final userId = await FlutterStoreCore.readUserId();
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thiếu thông tin người dùng')),
      );
      return;
    }
    await getIt<CreateOrderUseCase>().call(userId, orderItems).then((value) {
      if (value != null) {
        context.router.push(
          PaymentRoute(
            productName: 'Thanh toán giỏ hàng',
            amount: total,
            cartItems: items,
          ),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Tạo đơn hàng thất bại')));
      }
    });
  }
}

class _CartItemCard extends StatelessWidget {
  final CartItemResponse item;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;
  final VoidCallback onDelete;
  final VoidCallback onCheckout;

  const _CartItemCard({
    required this.item,
    required this.onDecrease,
    required this.onIncrease,
    required this.onDelete,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = _resolveImageUrl(item.imageUrl);
    final sizeText = (item.size ?? '').isEmpty ? '-' : item.size!;
    final colorText = (item.color ?? '').isEmpty ? '-' : item.color!;

    return Container(
      padding: const EdgeInsets.all(12),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 90,
              width: 90,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: const Offset(0, 4),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: imageUrl == null
                  ? const Icon(
                      Icons.image_not_supported_outlined,
                      color: Colors.grey,
                    )
                  : Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.broken_image_outlined,
                        color: Colors.grey,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.productName ?? 'Sản phẩm',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Kích cỡ: $sizeText | Màu: $colorText',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: onDelete,
                      child: const Icon(
                        Icons.delete_outline_rounded,
                        size: 18,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Format.formatCurrency(item.unitPrice),
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        _QuantityStepper(
                          value: item.quantity ?? 0,
                          onDecrease: onDecrease,
                          onIncrease: onIncrease,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        height: 32,
                        child: OutlinedButton(
                          onPressed: onCheckout,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black,
                            side: BorderSide(color: Colors.grey.shade300),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Đặt hàng',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String? _resolveImageUrl(String? path) {
    if (path == null || path.isEmpty) return null;
    if (path.startsWith('http')) return path;
    final normalizedBaseUrl = AppConfig().baseURL;
    return "$normalizedBaseUrl$path";
  }
}

class _QuantityStepper extends StatelessWidget {
  final int value;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  const _QuantityStepper({
    required this.value,
    required this.onDecrease,
    required this.onIncrease,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          _buildButton(Icons.remove, onDecrease),
          Container(
            constraints: const BoxConstraints(minWidth: 32),
            alignment: Alignment.center,
            child: Text(
              '$value',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          _buildButton(Icons.add, onIncrease),
        ],
      ),
    );
  }

  Widget _buildButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Icon(icon, size: 16, color: Colors.black87),
      ),
    );
  }
}
