import 'package:injectable/injectable.dart';

import '../repositories/order_repository.dart';
import '../../data/models/response/order_response.dart';

@injectable
class GetOrdersUseCase {
  final OrderRepository _repository;

  GetOrdersUseCase(this._repository);

  Future<List<OrderResponse>> call(int userId) {
    return _repository.getOrders(userId);
  }
}
