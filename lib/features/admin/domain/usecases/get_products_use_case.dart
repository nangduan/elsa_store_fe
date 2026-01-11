import 'package:injectable/injectable.dart';

import '../../data/models/response/product_response.dart';
import '../repositories/product_repository.dart';

@injectable
class GetProductsUseCase {
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  Future<List<ProductResponse>> call() {
    return repository.getProducts();
  }
}
