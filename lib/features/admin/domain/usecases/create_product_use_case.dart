import 'package:injectable/injectable.dart';

import '../../data/models/request/product_request.dart';
import '../../data/models/response/product_response.dart';
import '../repositories/product_repository.dart';

@injectable
class CreateProductUseCase {
  final ProductRepository repository;

  CreateProductUseCase(this.repository);

  Future<ProductResponse?> call(ProductRequest request) {
    return repository.createProduct(request);
  }
}
