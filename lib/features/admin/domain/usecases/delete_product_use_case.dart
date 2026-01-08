import 'package:injectable/injectable.dart';

import '../repositories/product_repository.dart';

@injectable
class DeleteProductUseCase {
  final ProductRepository repository;

  DeleteProductUseCase(this.repository);

  Future<void> call(int id) {
    return repository.deleteProduct(id);
  }
}
