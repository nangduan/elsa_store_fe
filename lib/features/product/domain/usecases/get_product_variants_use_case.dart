import 'package:injectable/injectable.dart';

import '../../data/models/response/product_variant_response.dart';
import '../repositories/product_repository.dart';

@injectable
class GetProductVariantsUseCase {
  final ProductRepository repository;

  GetProductVariantsUseCase(this.repository);

  Future<List<ProductVariantResponse>> call(int productId) {
    return repository.getProductVariants(productId);
  }
}
