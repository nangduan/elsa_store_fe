import '../../data/models/response/product_variant_response.dart';

abstract class ProductRepository {
  Future<List<ProductVariantResponse>> getProductVariants(int productId);
}
