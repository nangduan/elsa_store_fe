class ProductResponse {
  final int? id;
  final String? name;
  final String? description;
  final double? basePrice;
  final String? categoryName;

  ProductResponse({
    this.id,
    this.name,
    this.description,
    this.basePrice,
    this.categoryName,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      id: json['id'] as int?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      basePrice: (json['basePrice'] as num?)?.toDouble(),
      categoryName: json['categoryName'] as String?,
    );
  }
}
