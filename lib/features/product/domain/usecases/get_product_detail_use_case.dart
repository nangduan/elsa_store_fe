import 'package:injectable/injectable.dart';

import '../../data/models/response/product_detail_response.dart';
import '../repositories/product_repository.dart';

@injectable
class GetProductDetailUseCase {
  final ProductRepository repository;

  GetProductDetailUseCase(this.repository);

  Future<ProductDetailResponse?> call(int productId) {
    return repository.getProductDetail(productId);
  }
}
