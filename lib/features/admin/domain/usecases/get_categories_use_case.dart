import 'package:injectable/injectable.dart';

import '../../data/models/response/category_response.dart';
import '../repositories/category_repository.dart';

@injectable
class GetCategoriesUseCase {
  final CategoryRepository repository;

  GetCategoriesUseCase(this.repository);

  Future<List<CategoryResponse>> call() {
    return repository.getCategories();
  }
}
