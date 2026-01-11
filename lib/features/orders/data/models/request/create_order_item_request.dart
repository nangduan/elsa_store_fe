class CreateOrderItemRequest {
  final int productVariantId;
  final int quantity;

  CreateOrderItemRequest({
    required this.productVariantId,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'productVariantId': productVariantId,
      'quantity': quantity,
    };
  }
}
