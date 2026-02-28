import '../../data/models/response/category_response.dart';
import '../../data/models/response/product_response.dart';
import '../../../product/data/models/request/search_request.dart';

abstract class HomeRepository {
  Future<List<CategoryResponse>> getCategories();

  Future<List<ProductResponse>> getProducts({int? categoryId});

  Future<List<ProductResponse>> searchProducts(SearchProductRequest request);
}
