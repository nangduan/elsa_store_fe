import '../../data/models/request/category_request.dart';
import '../../data/models/response/category_response.dart';

abstract class CategoryRepository {
  Future<List<CategoryResponse>> getCategories();

  Future<CategoryResponse?> createCategory(CategoryRequest request);

  Future<CategoryResponse?> updateCategory(int id, CategoryRequest request);

  Future<void> deleteCategory(int id);
}
