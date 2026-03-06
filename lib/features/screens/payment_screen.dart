import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_skeleton/core/navigation/app_routes.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../core/api/app_config.dart';
import '../../core/constants/constant.dart';
import '../../core/constants/format.dart';
import '../../core/di/injector.dart';
import '../../core/storage/flutter_store_core.dart';
import '../cart/data/models/response/cart_item_response.dart';
import '../cart/domain/repositories/cart_repository.dart';
import '../cart/presentation/cubit/cart_cubit.dart';
import '../orders/presentation/cubit/order_cubit.dart';

@RoutePage()
class PaymentScreen extends StatefulWidget {
  const PaymentScreen({
    super.key,
    this.productName,
    this.imageUrl,
    this.amount,
    this.productVariantId,
    this.cartItems,
    this.onPaymentSuccess,
  });

  final String? productName;
  final String? imageUrl;
  final double? amount;
  final int? productVariantId;
  final List<CartItemResponse>? cartItems;
  final Future<int> Function(int paymentMethod)? onPaymentSuccess;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

enum PaymentMethod { cod, vnpay }

class _PaymentScreenState extends State<PaymentScreen> {
  PaymentMethod _method = PaymentMethod.cod;
  bool _isProcessing = false;
  String? _statusMessage;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.cartItems ?? const [];
    final displayAmount = widget.amount ?? _calculateCartTotal(items);
    final displayName = widget.productName ?? 'Sản phẩm';

    return Scaffold(
      appBar: AppBar(title: const Text('Đặt hàng')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _InfoTile(
            title: 'Địa chỉ giao hàng',
            subtitle: '26 Dong Da, Ward 2, District 2 Ho Chi Minh City',
          ),
          const _InfoTile(
            title: 'Thông tin liên hệ',
            subtitle: '+84900000000 example@gmail.com',
          ),
          const SizedBox(height: 8),
          const Text('Sản phẩm', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),

          Column(
            children:
                (items.isNotEmpty
                        ? items
                        : [
                            CartItemResponse(
                              productName: displayName,
                              imageUrl: widget.imageUrl,
                              unitPrice: displayAmount,
                              quantity: 1,
                              lineTotal: displayAmount,
                            ),
                          ])
                    .map((item) {
                      final itemTotal = _calculateItemTotal(item);
                      final itemImage = _resolveImageUrl(item.imageUrl);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              height: 56,
                              width: 56,
                              color: Colors.grey.shade100,
                              child: itemImage == null
                                  ? const Icon(
                                      Icons.image_not_supported_outlined,
                                      color: Colors.grey,
                                    )
                                  : Image.network(
                                      itemImage,
                                      fit: BoxFit.contain,
                                      errorBuilder: (_, __, ___) => const Icon(
                                        Icons.broken_image_outlined,
                                        color: Colors.grey,
                                      ),
                                    ),
                            ),
                          ),
                          title: Text(
                            item.productName ?? 'San pham',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text('x${item.quantity ?? 0}'),
                          trailing: Text(
                            Format.formatCurrency(itemTotal),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    })
                    .toList(),
          ),
          const SizedBox(height: 16),
          const Text(
            'Phương thức thanh toán',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          RadioListTile<PaymentMethod>(
            value: PaymentMethod.cod,
            groupValue: _method,
            onChanged: (value) {
              if (value == null) return;
              setState(() => _method = value);
            },
            title: const Text('Thanh toán khi nhận hàng'),
          ),
          RadioListTile<PaymentMethod>(
            value: PaymentMethod.vnpay,
            groupValue: _method,
            onChanged: (value) {
              if (value == null) return;
              setState(() => _method = value);
            },
            title: const Text('Thanh toán trực tuyến (VNPay)'),
          ),
          if (_statusMessage != null) ...[
            const SizedBox(height: 12),
            Text(
              _statusMessage!,
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ],
          const SizedBox(height: 24),
          Row(
            children: [
              const Text(
                'Tổng tiền',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                Format.formatCurrency(displayAmount),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _isProcessing ? null : _handlePay,
              child: Text(_isProcessing ? 'Đang xử lý...' : 'Đặt hàng'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handlePay() async {
    final amount =
        widget.amount ?? _calculateCartTotal(widget.cartItems ?? const []);
    if (amount <= 0) {
      _showSnackBar('So tien khong hop ly');
      return;
    }

    if (_method == PaymentMethod.cod) {
      setState(() => _isProcessing = true);
      try {
        final orderId = await _createOrderId();
        if (orderId == null) return;
        setState(() {
          _statusMessage = 'Dat hang thanh cong (thanh toan khi nhan hang)';
        });
        await _removeCartItemsIfNeeded();
        if (mounted) {
          _showSnackBar('Dat hang thanh cong');
          _exitAfterPayment();
        }
      } finally {
        if (mounted) {
          setState(() => _isProcessing = false);
        }
      }
      return;
    }

    setState(() => _isProcessing = true);
    try {
      final paymentUrl = await _createVnPayPayment(
        amount: amount,
        bankCode: "NCB",
      );
      if (!mounted || paymentUrl == null) return;
      final paymentResult = await Navigator.of(context).push<bool>(
        MaterialPageRoute(
          builder: (_) => VnPayWebViewScreen(
            url: paymentUrl,
            onCallback: _handleVnPayCallback,
          ),
        ),
      );
      if (!mounted) return;
      if (paymentResult != true) {
        await _removeCartItemsIfNeeded();
        _showSnackBar('Da huy thanh toan VNPay');
        _exitAfterPayment();
      }
    } on DioException catch (e) {
      _showSnackBar(e.message ?? 'Khong the tao thanh toan');
    } catch (_) {
      _showSnackBar('Khong the tao thanh toan');
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  Future<String?> _createVnPayPayment({
    required double amount,
    required String bankCode,
  }) async {
    final orderId = await _createOrderId();
    if (orderId == null) return null;
    final token = await _readAccessToken();

    final dio = getIt<Dio>();
    final response = await dio.get(
      '/payment/vn-pay',
      queryParameters: {'orderId': orderId, 'bankCode': bankCode},
      options: Options(
        headers: {
          if (token != null && token.isNotEmpty)
            'Authorization': 'Bearer $token',
        },
      ),
    );
    final data = response.data;
    if (data is Map<String, dynamic>) {
      final payload = data['data'];
      if (payload is Map<String, dynamic>) {
        return payload['paymentUrl'] as String?;
      }
    }
    _showSnackBar('Thanh toan that bai');
    return null;
  }

  Future<int?> _createOrderId() async {
    final paymentMethod = _method == PaymentMethod.cod ? 0 : 1;
    final orderId = await widget.onPaymentSuccess?.call(paymentMethod);
    if (orderId == null || orderId <= 0) {
      _showSnackBar('Tao don hang that bai');
      return null;
    }
    return orderId;
  }

  Future<void> _handleVnPayCallback(Uri callbackUri) async {
    setState(() => _isProcessing = true);
    try {
      final dio = getIt<Dio>();
      final response = await dio.get(
        '/payment/vn-pay-callback',
        queryParameters: callbackUri.queryParameters,
      );
      final data = response.data;
      String message = 'Thanh toán thất bại';
      if (data is Map<String, dynamic>) {
        final payload = data['data'];
        if (payload is Map<String, dynamic>) {
          message = payload['message'] as String? ?? message;
        } else if (payload is String) {
          message = payload;
        }
      }
      setState(() => _statusMessage = message);
      _showSnackBar(message);
      final isSuccess = _isVnPaySuccess(callbackUri, data, message);
      if (isSuccess) {
        await _removeCartItemsIfNeeded();
      }
    } on DioException catch (e) {
      _showSnackBar(e.message ?? 'Xác nhận thanh toán thất bại');
    } catch (_) {
      _showSnackBar('Xác nhận thanh toán thất bại');
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
      _exitAfterPayment();
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

  Future<String?> _readAccessToken() async {
    final storage = getIt<FlutterSecureStorage>();
    return storage.read(key: Constants.accessToken);
  }

  Future<void> _removeCartItemsIfNeeded() async {
    final items = widget.cartItems ?? const [];
    if (items.isEmpty) return;
    final userId = await FlutterStoreCore.readUserId();
    if (userId == null) return;
    final repo = getIt<CartRepository>();
    for (final item in items) {
      final itemId = item.id;
      if (itemId != null) {
        await repo.deleteItem(userId, itemId);
      }
    }
    _refreshTabsAfterPayment();
  }

  void _refreshTabsAfterPayment() {
    try {
      final cartCubit = BlocProvider.of<CartCubit>(context);
      cartCubit.load();
    } catch (_) {}
    try {
      final orderCubit = BlocProvider.of<OrderCubit>(context);
      orderCubit.load();
    } catch (_) {}
  }

  void _exitAfterPayment() {
    try {
      context.router.back();
      return;
    } catch (_) {}
    try {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
        return;
      }
    } catch (_) {}
    context.router.replaceAll([MainBottomNavRoute()]);
  }

  double _calculateItemTotal(CartItemResponse item) {
    return item.lineTotal ??
        (item.unitPrice != null && item.quantity != null
            ? item.unitPrice! * item.quantity!
            : 0);
  }

  double _calculateCartTotal(List<CartItemResponse> items) {
    return items.fold<double>(
      0,
      (sum, item) => sum + _calculateItemTotal(item),
    );
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  String? _resolveImageUrl(String? path) {
    if (path == null || path.isEmpty) return null;
    if (path.startsWith('http://') || path.startsWith('https://')) return path;
    return "${AppConfig().baseURL}$path";
  }
}

class _InfoTile extends StatelessWidget {
  final String title;
  final String subtitle;

  const _InfoTile({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.edit),
    );
  }
}

class VnPayWebViewScreen extends StatefulWidget {
  const VnPayWebViewScreen({
    super.key,
    required this.url,
    required this.onCallback,
  });

  final String url;
  final Future<void> Function(Uri callbackUri) onCallback;

  @override
  State<VnPayWebViewScreen> createState() => _VnPayWebViewScreenState();
}

class _VnPayWebViewScreenState extends State<VnPayWebViewScreen> {
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
