import '../../data/models/response/category_response.dart';
import '../../data/models/response/product_response.dart';

abstract class HomeRepository {
  Future<List<CategoryResponse>> getCategories();

  Future<List<ProductResponse>> getProducts();
}
