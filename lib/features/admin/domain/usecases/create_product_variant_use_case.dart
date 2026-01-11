import 'package:injectable/injectable.dart';

import '../../data/models/request/product_variant_request.dart';
import '../../../product/data/models/response/product_variant_response.dart';
import '../repositories/product_variant_repository.dart';

@injectable
class CreateProductVariantUseCase {
  final ProductVariantRepository repository;

  CreateProductVariantUseCase(this.repository);

  Future<ProductVariantResponse?> call(ProductVariantRequest request) {
    return repository.createProductVariant(request);
  }
}
