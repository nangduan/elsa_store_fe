import 'package:injectable/injectable.dart';

import '../../data/models/request/product_variant_request.dart';
import '../../../product/data/models/response/product_variant_response.dart';
import '../repositories/product_variant_repository.dart';

@injectable
class UpdateProductVariantUseCase {
  final ProductVariantRepository repository;

  UpdateProductVariantUseCase(this.repository);

  Future<ProductVariantResponse?> call(int id, ProductVariantRequest request) {
    return repository.updateProductVariant(id, request);
  }
}
