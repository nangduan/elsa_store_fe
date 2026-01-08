import 'package:injectable/injectable.dart';

import '../../../product/data/models/response/product_variant_response.dart';
import '../repositories/product_variant_repository.dart';

@injectable
class GetAdminProductVariantsUseCase {
  final ProductVariantRepository repository;

  GetAdminProductVariantsUseCase(this.repository);

  Future<List<ProductVariantResponse>> call(int productId) {
    return repository.getProductVariants(productId);
  }
}
