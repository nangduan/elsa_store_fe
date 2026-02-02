import 'package:injectable/injectable.dart';

import '../../data/models/response/revenue_top_product_response.dart';
import '../repositories/revenue_repository.dart';

@injectable
class GetRevenueTopProductsUseCase {
  final RevenueRepository _repository;

  GetRevenueTopProductsUseCase(this._repository);

  Future<List<RevenueTopProductResponse>> call({
    required String from,
    required String to,
    required List<int> statuses,
  }) {
    return _repository.getTopProducts(
      from: from,
      to: to,
      statuses: statuses,
    );
  }
}
