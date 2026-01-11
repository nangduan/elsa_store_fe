class AddCartItemRequest {
  final int productVariantId;
  final int quantity;

  AddCartItemRequest({required this.productVariantId, required this.quantity});

  Map<String, dynamic> toJson() {
    return {
      'productVariantId': productVariantId,
      'quantity': quantity,
    };
  }
}
