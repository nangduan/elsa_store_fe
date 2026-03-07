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

  final Color _primaryBlue = const Color(0xFF1964D4);
  final Color _primaryOrange = const Color(0xFFE85022);
  final Color _bgColor = const Color(0xFFFAFAFA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        title: Text(
          'GIỎ HÀNG',
          style: TextStyle(
            color: _primaryBlue,
            fontWeight: FontWeight.w900,
            fontSize: 18,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        backgroundColor: _bgColor,
        elevation: 0,
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back_ios_new, color: _primaryBlue, size: 20),
        //   onPressed: () {
        //     if (context.router.canPop()) {
        //       context.router.pop();
        //     }
        //   },
        // ),
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state.status == CartStatus.loading) {
            return Center(
              child: CircularProgressIndicator(color: _primaryBlue),
            );
          }

          if (state.status == CartStatus.failure) {
            Future<void> onRetry() => context.read<CartCubit>().load();
            return RefreshIndicator(
              color: _primaryBlue,
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
              color: _primaryBlue,
              onRefresh: () => context.read<CartCubit>().load(),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: 120),
                  _buildEmptyState(context),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  color: _primaryBlue,
                  onRefresh: () => context.read<CartCubit>().load(),
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
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
                            _confirmDelete(context, item);
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
        Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Color(0xFFFCEAE8),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.error_outline, size: 48, color: _primaryOrange),
        ),
        const SizedBox(height: 16),
        Text(
          message ?? 'Không tải được giỏ hàng',
          style: const TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          style: TextButton.styleFrom(foregroundColor: _primaryBlue),
          onPressed: () => onRetry(),
          child: const Text(
            'Thử lại',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Color(0xFFEAF1F8),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.shopping_cart_outlined,
            size: 64,
            color: _primaryBlue.withOpacity(0.5),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Giỏ hàng đang trống',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Hãy thêm vài món đồ sành điệu vào nhé!',
          style: TextStyle(color: Colors.black54),
        ),
        const SizedBox(height: 32),
        // ElevatedButton(
        //   style: ElevatedButton.styleFrom(
        //     backgroundColor: _primaryBlue,
        //     foregroundColor: Colors.white,
        //     padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
        //     elevation: 0,
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(28),
        //     ),
        //   ),
        //   onPressed: () {
        //     // Có thể navigate về trang chủ hoặc trang sản phẩm tùy ý
        //     context.router.maybePop();
        //   },
        //   child: const Text(
        //     'TIẾP TỤC MUA SẮM',
        //     style: TextStyle(fontWeight: FontWeight.bold),
        //   ),
        // ),
      ],
    );
  }

  void _confirmDelete(BuildContext context, CartItemResponse item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          'Xóa sản phẩm',
          style: TextStyle(color: _primaryOrange, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Bạn có chắc chắn muốn xóa sản phẩm này khỏi giỏ hàng?',
          style: TextStyle(color: Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Hủy',
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFCEAE8),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              context.read<CartCubit>().deleteItem(item.id!);
              Navigator.pop(ctx);
            },
            child: Text(
              'Xóa',
              style: TextStyle(
                color: _primaryOrange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
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
      _showSnackBar(context, 'Du lieu san pham khong hop le', isError: true);
      return;
    }

    await _openPaymentAndRefresh(
      context,
      PaymentRoute(
        productName: item.productName ?? 'San pham',
        imageUrl: item.imageUrl,
        amount: amount,
        cartItems: [item],
        onPaymentSuccess: (paymentMethod) =>
            _createOrderForCartItems(context, [item], paymentMethod),
      ),
    );
  }

  Widget _buildBottomCheckout(
    BuildContext context,
    double? total,
    List<CartItemResponse> items,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            offset: const Offset(0, -4),
            blurRadius: 20,
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Text(
                  'Tổng thanh toán:',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  Format.formatCurrency(total),
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                    color: _primaryOrange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                onPressed: () => _checkoutAll(context, items),
                child: const Text(
                  'THANH TOÁN TẤT CẢ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 0.5,
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
      _showSnackBar(context, 'Gio hang dang trong');
      return;
    }

    await _openPaymentAndRefresh(
      context,
      PaymentRoute(
        productName: 'Thanh toan gio hang',
        amount: total,
        cartItems: items,
        onPaymentSuccess: (paymentMethod) =>
            _createOrderForCartItems(context, items, paymentMethod),
      ),
    );
  }

  Future<int> _createOrderForCartItems(
    BuildContext context,
    List<CartItemResponse> items,
    int paymentMethod,
  ) async {
    if (items.isEmpty) {
      _showSnackBar(context, 'Gio hang dang trong', isError: true);
      return 0;
    }

    final userId = await FlutterStoreCore.readUserId();
    if (userId == null) {
      _showSnackBar(context, 'Thieu thong tin nguoi dung', isError: true);
      return 0;
    }

    final orderItems = <CreateOrderItemRequest>[];
    for (final item in items) {
      final variantId = item.productVariantId;
      final quantity = item.quantity ?? 1;
      if (variantId == null || quantity <= 0) {
        _showSnackBar(context, 'Du lieu san pham khong hop le', isError: true);
        return 0;
      }
      orderItems.add(
        CreateOrderItemRequest(productVariantId: variantId, quantity: quantity),
      );
    }

    final order = await getIt<CreateOrderUseCase>().call(
      userId,
      orderItems,
      paymentMethod: paymentMethod,
    );
    final orderId = order?.id;
    if (orderId == null || orderId <= 0) {
      _showSnackBar(context, 'Tao don hang that bai', isError: true);
      return 0;
    }
    return orderId;
  }

  Future<void> _openPaymentAndRefresh(
    BuildContext context,
    PageRouteInfo route,
  ) async {
    await context.router.push(route);
    if (!context.mounted) return;
    context.read<CartCubit>().load();
    try {
      final orderCubit = BlocProvider.of<OrderCubit>(context);
      orderCubit.load();
    } catch (_) {}
  }

  void _showSnackBar(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
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
    final Color primaryBlue = const Color(0xFF1964D4);
    final Color primaryOrange = const Color(0xFFE85022);

    final imageUrl = _resolveImageUrl(item.imageUrl);
    final sizeText = (item.size ?? '').isEmpty ? '-' : item.size!;
    final colorText = (item.color ?? '').isEmpty ? '-' : item.color!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Container(
            height: 90,
            width: 90,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: imageUrl == null
                  ? const Icon(
                      Icons.inventory_2_outlined,
                      color: Colors.black26,
                      size: 32,
                    )
                  : Image.network(
                      imageUrl,
                      fit: BoxFit.fitWidth,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.broken_image_outlined,
                        color: Colors.black26,
                        size: 32,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 16),
          // Info
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
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAF1F8),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '$colorText - Size $sizeText',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: primaryBlue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: onDelete,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFCEAE8),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.delete_outline_rounded,
                          size: 18,
                          color: primaryOrange,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Format.formatCurrency(item.unitPrice),
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
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
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    height: 36,
                    child: OutlinedButton(
                      onPressed: onCheckout,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: primaryBlue,
                        side: BorderSide(color: primaryBlue.withOpacity(0.5)),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Thanh toán riêng',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
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
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }

    final cleanPath = path.startsWith('/') ? path.substring(1) : path;
    final cleanBase = AppConfig().baseURL.endsWith('/')
        ? AppConfig().baseURL
        : '${AppConfig().baseURL}/';

    return "$cleanBase$cleanPath";
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
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
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
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Icon(icon, size: 16, color: Colors.black87),
      ),
    );
  }
}
