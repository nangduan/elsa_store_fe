import 'package:injectable/injectable.dart';

import '../repositories/category_repository.dart';

@injectable
class DeleteCategoryUseCase {
  final CategoryRepository repository;

  DeleteCategoryUseCase(this.repository);

  Future<void> call(int id) {
    return repository.deleteCategory(id);
  }
}
