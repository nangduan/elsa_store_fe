import 'package:injectable/injectable.dart';

import '../../data/models/request/product_request.dart';
import '../../data/models/response/product_response.dart';
import '../repositories/product_repository.dart';

@injectable
class UpdateProductUseCase {
  final ProductRepository repository;

  UpdateProductUseCase(this.repository);

  Future<ProductResponse?> call(int id, ProductRequest request) {
    return repository.updateProduct(id, request);
  }
}
