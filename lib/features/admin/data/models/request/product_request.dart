class ProductRequest {
  final String name;
  final String description;
  final double basePrice;
  final int categoryId;
  final String? imagePath;

  ProductRequest({
    required this.name,
    required this.description,
    required this.basePrice,
    required this.categoryId,
    this.imagePath,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'basePrice': basePrice,
    'categoryId': categoryId,
  };
}
