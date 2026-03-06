import 'create_order_item_request.dart';

class CreateOrderRequest {
  final int userId;
  final List<CreateOrderItemRequest> items;
  final int paymentMethod;

  CreateOrderRequest({
    required this.userId,
    required this.items,
    required this.paymentMethod,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'paymentMethod': paymentMethod,
    };
  }
}
