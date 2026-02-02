class RevenueTopProductResponse {
  final int? productVariantId;
  final String? productName;
  final String? imageUrl;
  final int? quantitySold;
  final double? revenue;

  RevenueTopProductResponse({
    this.productVariantId,
    this.productName,
    this.imageUrl,
    this.quantitySold,
    this.revenue,
  });

  factory RevenueTopProductResponse.fromJson(Map<String, dynamic> json) {
    return RevenueTopProductResponse(
      productVariantId: json['productVariantId'] as int?,
      productName: json['productName'] as String?,
      imageUrl: json['imageUrl'] as String?,
      quantitySold: json['quantitySold'] as int?,
      revenue: (json['revenue'] as num?)?.toDouble(),
    );
  }
}
