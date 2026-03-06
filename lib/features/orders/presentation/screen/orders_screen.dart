import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_skeleton/core/di/injector.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../core/api/app_config.dart';
import '../../../../core/constants/format.dart';
import '../../data/models/response/order_response.dart';
import '../cubit/order_cubit.dart';

@RoutePage()
class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          OrderCubit(getIt(), getIt(), getIt(), getIt())..load(),
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
                  return _OrderCard(order: order, isAdmin: state.isAdmin);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class _OrderCard extends StatefulWidget {
  final OrderResponse order;
  final bool isAdmin;

  const _OrderCard({required this.order, required this.isAdmin});

  @override
  State<_OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<_OrderCard> {
  OrderResponse get order => widget.order;

  @override
  Widget build(BuildContext context) {
    final code = order.code ?? '-';
    final date = order.orderDate ?? '-';
    final total = Format.formatCurrency(order.finalAmount);
    final status = _statusLabel(order.status);
    final orderStatusColor = _orderStatusColor(order.status);
    final orderStatusTextColor = _orderStatusTextColor(order.status);
    final paymentStatus = _paymentStatusLabel(order);
    final actionButtons = _buildActions(context);

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
              _StatusChip(
                label: status,
                backgroundColor: orderStatusColor,
                textColor: orderStatusTextColor,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            date,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _StatusChip(
                label: paymentStatus,
                backgroundColor: _paymentStatusColor(order),
                textColor: _paymentStatusTextColor(order),
              ),
            ],
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
          if (actionButtons.isNotEmpty) ...[
            const Divider(height: 24),
            Wrap(spacing: 8, runSpacing: 8, children: actionButtons),
          ],
        ],
      ),
    );
  }

  String _statusLabel(String? status) {
    switch (status) {
      case 'CHUA_XAC_NHAN':
        return 'Chờ xác nhận';
      case 'DA_XAC_NHAN':
        return 'Đã xác nhận';
      case 'HOAN_THANH':
        return 'Hoàn tất';
      case 'DA_HUY':
        return 'Đã hủy';
      default:
        return 'Không rõ';
    }
  }

  String _paymentStatusLabel(OrderResponse order) {
    final status = _normalize(order.paymentStatus);
    if (_isCod(order) || _matches(status, const ['CHUA_THANH_TOAN'])) {
      return 'Thanh toan khi nhan hang';
    }

    if (status.isEmpty) return 'Cho thanh toan';
    if (_matches(status, const ['DA_THANH_TOAN', 'PAID', 'SUCCESS'])) {
      return 'Da thanh toan';
    }
    if (_matches(status, const ['CHO_THANH_TOAN', 'PENDING', 'UNPAID'])) {
      return 'Cho thanh toan';
    }
    if (_matches(status, const ['THAT_BAI', 'FAILED', 'CANCELLED'])) {
      return 'Thanh toan that bai';
    }
    return 'Khong ro';
  }

  Color _paymentStatusColor(OrderResponse order) {
    final status = _normalize(order.paymentStatus);
    if (_isCod(order) || _matches(status, const ['CHUA_THANH_TOAN'])) {
      return Colors.orange.shade50;
    }
    if (_matches(status, const ['DA_THANH_TOAN', 'PAID', 'SUCCESS'])) {
      return Colors.green.shade50;
    }
    if (_matches(status, const ['THAT_BAI', 'FAILED', 'CANCELLED'])) {
      return Colors.red.shade50;
    }
    return Colors.blue.shade50;
  }

  Color _orderStatusColor(String? status) {
    switch (_normalize(status)) {
      case 'CHUA_XAC_NHAN':
        return Colors.orange.shade50;
      case 'DA_XAC_NHAN':
        return Colors.blue.shade50;
      case 'HOAN_THANH':
        return Colors.green.shade50;
      case 'DA_HUY':
        return Colors.red.shade50;
      default:
        return Colors.grey.shade100;
    }
  }

  Color _orderStatusTextColor(String? status) {
    switch (_normalize(status)) {
      case 'CHUA_XAC_NHAN':
        return Colors.orange.shade700;
      case 'DA_XAC_NHAN':
        return Colors.blue.shade700;
      case 'HOAN_THANH':
        return Colors.green.shade700;
      case 'DA_HUY':
        return Colors.red.shade700;
      default:
        return Colors.grey.shade700;
    }
  }

  Color _paymentStatusTextColor(OrderResponse order) {
    final status = _normalize(order.paymentStatus);
    if (_isCod(order) || _matches(status, const ['CHUA_THANH_TOAN'])) {
      return Colors.orange.shade700;
    }
    if (_matches(status, const ['DA_THANH_TOAN', 'PAID', 'SUCCESS'])) {
      return Colors.green.shade700;
    }
    if (_matches(status, const ['THAT_BAI', 'FAILED', 'CANCELLED'])) {
      return Colors.red.shade700;
    }
    return Colors.blue.shade700;
  }

  bool _canContinuePayment(OrderResponse order) {
    if (widget.isAdmin) {
      return false;
    }
    final paymentMethod = _normalize(order.paymentMethod);
    if (_matches(paymentMethod, const ['COD', 'CASH_ON_DELIVERY'])) {
      return false;
    }
    final orderStatus = _normalize(order.status);
    if (_matches(orderStatus, const ['DA_HUY', 'HOAN_THANH'])) {
      return false;
    }
    final status = _normalize(order.paymentStatus);
    if (_matches(status, const ['DA_THANH_TOAN', 'PAID', 'SUCCESS'])) {
      return false;
    }
    return status.isEmpty ||
        _matches(status, const ['CHO_THANH_TOAN', 'PENDING', 'UNPAID']);
  }

  List<Widget> _buildActions(BuildContext context) {
    final actions = <Widget>[];
    final status = order.status ?? '';
    final orderId = order.id;

    if (orderId != null && status == 'CHUA_XAC_NHAN') {
      actions.add(
        OutlinedButton(
          onPressed: () async {
            final confirmed = await _confirmDialog(
              context,
              'Hủy đơn hàng?',
              'Bạn có chắc chắn muốn hủy đơn hàng này không?',
            );
            if (!confirmed) return;
            await _handleUpdateStatus(
              context,
              orderId,
              'DA_HUY',
              successMessage: 'Đã hủy đơn hàng',
            );
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.red.shade600,
            side: BorderSide(color: Colors.red.shade200),
          ),
          child: const Text('Hủy'),
        ),
      );
      if (widget.isAdmin) {
        actions.add(
          ElevatedButton(
            onPressed: () async {
              final confirmed = await _confirmDialog(
                context,
                'Xác nhận đơn hàng?',
                'Xác nhận đơn hàng này?',
              );
              if (!confirmed) return;
              await _handleUpdateStatus(
                context,
                orderId,
                'DA_XAC_NHAN',
                successMessage: 'Đã xác nhận đơn hàng',
              );
            },
            child: const Text('Xác nhận'),
          ),
        );
      }
    }

    if (widget.isAdmin && orderId != null && status == 'DA_XAC_NHAN') {
      actions.add(
        ElevatedButton(
          onPressed: () async {
            final confirmed = await _confirmDialog(
              context,
              'Hoàn thành đơn hàng?',
              'Đánh dấu đơn hàng đã hoàn thành?',
            );
            if (!confirmed) return;
            await _handleUpdateStatus(
              context,
              orderId,
              'HOAN_THANH',
              successMessage: 'Đã hoàn thành đơn hàng',
            );
          },
          child: const Text('Hoàn thành'),
        ),
      );
    }

    if (_canContinuePayment(order)) {
      actions.add(
        OutlinedButton.icon(
          onPressed: () => _handleContinuePayment(context, order),
          icon: const Icon(Icons.payment_outlined, size: 18),
          label: const Text('Tiếp tục thanh toán'),
        ),
      );
    }

    return actions;
  }

  Future<void> _handleUpdateStatus(
    BuildContext context,
    int orderId,
    String status, {
    String? successMessage,
  }) async {
    try {
      await context.read<OrderCubit>().updateOrderStatus(
        orderId: orderId,
        status: status,
      );
      if (successMessage != null) {
        _showSnackBar(context, successMessage);
      }
    } catch (_) {
      _showSnackBar(context, 'KhÃ´ng thá»ƒ cáº­p nháº­t Ä‘Æ¡n hÃ ng');
    }
  }

  Future<void> _handleContinuePayment(
    BuildContext context,
    OrderResponse order,
  ) async {
    final orderId = order.id;
    if (orderId == null) {
      _showSnackBar(context, 'Khong tim thay ma don hang');
      return;
    }
    try {
      final dio = getIt<Dio>();
      final response = await dio.get(
        '/payment/vn-pay',
        queryParameters: {'orderId': orderId, 'bankCode': 'NCB'},
      );
      final data = response.data;
      String? paymentUrl;
      if (data is Map<String, dynamic>) {
        final payload = data['data'];
        if (payload is Map<String, dynamic>) {
          paymentUrl = payload['paymentUrl'] as String?;
        }
      }
      if (paymentUrl == null || paymentUrl.trim().isEmpty) {
        _showSnackBar(context, 'Khong lay duoc lien ket thanh toan');
        return;
      }

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => _OrderVnPayWebViewScreen(
            url: paymentUrl!,
            onCallback: (callbackUri) =>
                _handleVnPayCallback(context, orderId, callbackUri),
          ),
        ),
      );
    } on DioException catch (e) {
      _showSnackBar(context, e.message ?? 'Khong the tao thanh toan');
    } catch (_) {
      _showSnackBar(context, 'Khong the tao thanh toan');
    }
  }

  Future<void> _handleVnPayCallback(
    BuildContext context,
    int orderId,
    Uri callbackUri,
  ) async {
    try {
      final dio = getIt<Dio>();
      final response = await dio.get(
        '/payment/vn-pay-callback',
        queryParameters: callbackUri.queryParameters,
      );
      final data = response.data;
      String message = 'Thanh toan that bai';
      if (data is Map<String, dynamic>) {
        final payload = data['data'];
        if (payload is Map<String, dynamic>) {
          message = payload['message'] as String? ?? message;
        } else if (payload is String) {
          message = payload;
        }
      }
      _showSnackBar(context, message);
      final isSuccess = _isVnPaySuccess(callbackUri, data, message);
      if (isSuccess) {
        await context.read<OrderCubit>().updatePaymentStatus(
          orderId: orderId,
          paymentStatus: 'DA_THANH_TOAN',
        );
      }
    } on DioException catch (e) {
      _showSnackBar(context, e.message ?? 'Xac nhan thanh toan that bai');
    } catch (_) {
      _showSnackBar(context, 'Xac nhan thanh toan that bai');
    }
  }

  bool _isPaymentSuccess(String message) {
    final lower = message.toLowerCase();
    return lower.contains('thanh cong') || lower.contains('success');
  }

  bool _isVnPaySuccess(Uri callbackUri, dynamic responseData, String message) {
    final responseCode =
        callbackUri.queryParameters['vnp_ResponseCode'] ??
        callbackUri.queryParameters['vnp_responsecode'];
    if (responseCode == '00') {
      return true;
    }
    if (responseData is Map<String, dynamic>) {
      final ok = responseData['success'];
      if (ok is bool && ok) {
        return true;
      }
    }
    return _isPaymentSuccess(message);
  }

  Future<bool> _confirmDialog(
    BuildContext context,
    String title,
    String content,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Xác nhận'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  String _normalize(String? value) {
    return (value ?? '').trim().toUpperCase();
  }

  bool _isCod(OrderResponse order) {
    final method = _normalize(order.paymentMethod);
    if (method == 'COD' || method == 'CASH_ON_DELIVERY' || method == '0') {
      return true;
    }
    final statusEmpty =
        order.paymentStatus == null || order.paymentStatus!.trim().isEmpty;
    final urlEmpty =
        order.paymentUrl == null || order.paymentUrl!.trim().isEmpty;
    return method.isEmpty && statusEmpty && urlEmpty;
  }

  bool _matches(String value, List<String> options) {
    return options.any((option) => value == option);
  }

  String? _resolveImageUrl(String? path) {
    if (path == null || path.isEmpty) return null;
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }
    return "${AppConfig().baseURL}$path";
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;

  const _StatusChip({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _OrderVnPayWebViewScreen extends StatefulWidget {
  const _OrderVnPayWebViewScreen({required this.url, required this.onCallback});

  final String url;
  final Future<void> Function(Uri callbackUri) onCallback;

  @override
  State<_OrderVnPayWebViewScreen> createState() =>
      _OrderVnPayWebViewScreenState();
}

class _OrderVnPayWebViewScreenState extends State<_OrderVnPayWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) => setState(() => _isLoading = false),
          onNavigationRequest: (request) async {
            final uri = Uri.tryParse(request.url);
            if (uri != null && uri.path.contains('/payment/vn-pay-callback')) {
              await widget.onCallback(uri);
              if (mounted) Navigator.of(context).pop(true);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('VNPay')),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(child: CircularProgressIndicator(color: Colors.black)),
        ],
      ),
    );
  }
}
