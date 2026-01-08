class ProductVariantResponse {
  final int? id;
  final int? productId;
  final String? productName;
  final String? color;
  final String? size;
  final String? sku;
  final double? price;
  final int? status;

  ProductVariantResponse({
    this.id,
    this.productId,
    this.productName,
    this.color,
    this.size,
    this.sku,
    this.price,
    this.status,
  });

  factory ProductVariantResponse.fromJson(Map<String, dynamic> json) {
    return ProductVariantResponse(
      id: json['id'] as int?,
      productId: json['productId'] as int?,
      productName: json['productName'] as String?,
      color: json['color'] as String?,
      size: json['size'] as String?,
      sku: json['sku'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      status: json['status'] as int?,
    );
  }
}
