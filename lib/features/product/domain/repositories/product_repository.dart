import '../../data/models/response/product_detail_response.dart';
import '../../data/models/response/product_variant_response.dart';

abstract class ProductRepository {
  Future<ProductDetailResponse?> getProductDetail(int productId);
  Future<List<ProductVariantResponse>> getProductVariants(int productId);
}
