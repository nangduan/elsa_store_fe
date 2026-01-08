import 'package:injectable/injectable.dart';

import '../../data/models/request/category_request.dart';
import '../../data/models/response/category_response.dart';
import '../repositories/category_repository.dart';

@injectable
class UpdateCategoryUseCase {
  final CategoryRepository repository;

  UpdateCategoryUseCase(this.repository);

  Future<CategoryResponse?> call(int id, CategoryRequest request) {
    return repository.updateCategory(id, request);
  }
}
