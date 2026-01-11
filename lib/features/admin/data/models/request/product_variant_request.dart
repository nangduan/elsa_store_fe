class ProductVariantRequest {
  final int productId;
  final String color;
  final String size;
  final String sku;
  final double price;
  final int status;

  ProductVariantRequest({
    required this.productId,
    required this.color,
    required this.size,
    required this.sku,
    required this.price,
    required this.status,
  });

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'color': color,
        'size': size,
        'sku': sku,
        'price': price,
        'status': status,
      };
}
