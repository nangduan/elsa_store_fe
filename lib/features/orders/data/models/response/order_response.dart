import 'order_item_response.dart';

class OrderResponse {
  final int? id;
  final String? code;
  final String? orderDate;
  final double? totalAmount;
  final double? finalAmount;
  final String? status;
  final String? paymentMethod;
  final String? paymentStatus;
  final String? paymentUrl;
  final List<OrderItemResponse> items;

  OrderResponse({
    this.id,
    this.code,
    this.orderDate,
    this.totalAmount,
    this.finalAmount,
    this.status,
    this.paymentMethod,
    this.paymentStatus,
    this.paymentUrl,
    this.items = const [],
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    return OrderResponse(
      id: json['id'] as int?,
      code: json['code'] as String?,
      orderDate: json['orderDate'] as String?,
      totalAmount: (json['totalAmount'] as num?)?.toDouble(),
      finalAmount: (json['finalAmount'] as num?)?.toDouble(),
      status: json['status'] as String?,
      paymentMethod: json['paymentMethod'] as String?,
      paymentStatus: json['paymentStatus'] as String?,
      paymentUrl: json['paymentUrl'] as String?,
      items: rawItems is List
          ? rawItems
                .whereType<Map<String, dynamic>>()
                .map(OrderItemResponse.fromJson)
                .toList()
          : const [],
    );
  }
}
