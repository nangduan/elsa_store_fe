import '../../data/models/request/product_variant_request.dart';
import '../../../product/data/models/response/product_variant_response.dart';

abstract class ProductVariantRepository {
  Future<List<ProductVariantResponse>> getProductVariants(int productId);
  Future<ProductVariantResponse?> createProductVariant(
    ProductVariantRequest request,
  );
  Future<ProductVariantResponse?> updateProductVariant(
    int id,
    ProductVariantRequest request,
  );
  Future<void> deleteProductVariant(int id);
}
