import 'package:injectable/injectable.dart';

import '../../data/models/request/category_request.dart';
import '../../data/models/response/category_response.dart';
import '../repositories/category_repository.dart';

@injectable
class CreateCategoryUseCase {
  final CategoryRepository repository;

  CreateCategoryUseCase(this.repository);

  Future<CategoryResponse?> call(CategoryRequest request) {
    return repository.createCategory(request);
  }
}
