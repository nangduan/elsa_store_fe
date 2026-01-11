import '../../data/models/request/product_request.dart';
import '../../data/models/response/product_response.dart';

abstract class ProductRepository {
  Future<List<ProductResponse>> getProducts();
  Future<ProductResponse?> createProduct(ProductRequest request);
  Future<ProductResponse?> updateProduct(int id, ProductRequest request);
  Future<void> deleteProduct(int id);
}
