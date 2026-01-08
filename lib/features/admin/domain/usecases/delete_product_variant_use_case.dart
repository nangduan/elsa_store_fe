import 'package:injectable/injectable.dart';

import '../repositories/product_variant_repository.dart';

@injectable
class DeleteProductVariantUseCase {
  final ProductVariantRepository repository;

  DeleteProductVariantUseCase(this.repository);

  Future<void> call(int id) {
    return repository.deleteProductVariant(id);
  }
}
