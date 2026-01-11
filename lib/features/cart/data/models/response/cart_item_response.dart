class CartItemResponse {
  final int? id;
  final int? productVariantId;
  final String? productName;
  final String? color;
  final String? size;
  final String? sku;
  final String? imageUrl;
  final double? unitPrice;
  final int? quantity;
  final double? lineTotal;

  CartItemResponse({
    this.id,
    this.productVariantId,
    this.productName,
    this.color,
    this.size,
    this.sku,
    this.imageUrl,
    this.unitPrice,
    this.quantity,
    this.lineTotal,
  });

  factory CartItemResponse.fromJson(Map<String, dynamic> json) {
    return CartItemResponse(
      id: json['id'] as int?,
      productVariantId: json['productVariantId'] as int?,
      productName: json['productName'] as String?,
      color: json['color'] as String?,
      size: json['size'] as String?,
      sku: json['sku'] as String?,
      imageUrl: json['imageUrl'] as String?,
      unitPrice: (json['unitPrice'] as num?)?.toDouble(),
      quantity: json['quantity'] as int?,
      lineTotal: (json['lineTotal'] as num?)?.toDouble(),
    );
  }
}
