import 'create_order_item_request.dart';

class CreateOrderRequest {
  final int userId;
  final List<CreateOrderItemRequest> items;

  CreateOrderRequest({
    required this.userId,
    required this.items,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}
