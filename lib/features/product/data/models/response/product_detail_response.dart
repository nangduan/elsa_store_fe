import 'product_variant_response.dart';

class ProductDetailResponse {
  final int? id;
  final String? imageUrl;
  final String? name;
  final String? description;
  final double? basePrice;
  final String? categoryName;
  final List<String> images;
  final List<ProductVariantResponse> productVariants;

  ProductDetailResponse({
    this.id,
    this.imageUrl,
    this.name,
    this.description,
    this.basePrice,
    this.categoryName,
    this.images = const [],
    this.productVariants = const [],
  });

  factory ProductDetailResponse.fromJson(Map<String, dynamic> json) {
    final rawImages = json['images'];
    final rawVariants = json['productVariants'];

    return ProductDetailResponse(
      id: json['id'] as int?,
      imageUrl: json['imageUrl'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      basePrice: (json['basePrice'] as num?)?.toDouble(),
      categoryName: json['categoryName'] as String?,
      images:
          rawImages is List
              ? rawImages.whereType<String>().toList()
              : const [],
      productVariants:
          rawVariants is List
              ? rawVariants
                  .whereType<Map<String, dynamic>>()
                  .map(ProductVariantResponse.fromJson)
                  .toList()
              : const [],
    );
  }
}
