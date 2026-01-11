import 'cart_item_response.dart';

class CartResponse {
  final int? cartId;
  final int? userId;
  final List<CartItemResponse> items;
  final double? totalAmount;

  CartResponse({
    this.cartId,
    this.userId,
    this.items = const [],
    this.totalAmount,
  });

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    return CartResponse(
      cartId: json['cartId'] as int?,
      userId: json['userId'] as int?,
      items:
          rawItems is List
              ? rawItems
                  .whereType<Map<String, dynamic>>()
                  .map(CartItemResponse.fromJson)
                  .toList()
              : const [],
      totalAmount: (json['totalAmount'] as num?)?.toDouble(),
    );
  }
}
