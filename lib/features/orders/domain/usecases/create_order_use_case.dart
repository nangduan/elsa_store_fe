import 'package:injectable/injectable.dart';

import '../../data/models/request/create_order_item_request.dart';
import '../../data/models/response/order_response.dart';
import '../repositories/order_repository.dart';

@injectable
class CreateOrderUseCase {
  final OrderRepository _repository;

  CreateOrderUseCase(this._repository);

  Future<OrderResponse?> call(int userId, List<CreateOrderItemRequest> items) {
    return _repository.createOrder(userId, items);
  }
}
