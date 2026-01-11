class OrderItemResponse {
  final int? productVariantId;
  final String? productName;
  final int? quantity;
  final double? unitPrice;
  final double? lineTotal;

  OrderItemResponse({
    this.productVariantId,
    this.productName,
    this.quantity,
    this.unitPrice,
    this.lineTotal,
  });

  factory OrderItemResponse.fromJson(Map<String, dynamic> json) {
    return OrderItemResponse(
      productVariantId: json['productVariantId'] as int?,
      productName: json['productName'] as String?,
      quantity: json['quantity'] as int?,
      unitPrice: (json['unitPrice'] as num?)?.toDouble(),
      lineTotal: (json['lineTotal'] as num?)?.toDouble(),
    );
  }
}
