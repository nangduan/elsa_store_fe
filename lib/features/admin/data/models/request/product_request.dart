class ProductRequest {
  final String name;
  final String description;
  final double basePrice;
  final int categoryId;

  ProductRequest({
    required this.name,
    required this.description,
    required this.basePrice,
    required this.categoryId,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'basePrice': basePrice,
        'categoryId': categoryId,
      };
}
