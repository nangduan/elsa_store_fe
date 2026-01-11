import '../repositories/order_repository.dart';
import '../../data/models/response/order_response.dart';

class GetOrdersUseCase {
  final OrderRepository _repository;

  GetOrdersUseCase(this._repository);

  Future<List<OrderResponse>> call(int userId) {
    return _repository.getOrders(userId);
  }
}
