import 'package:injectable/injectable.dart';

import '../../data/models/response/order_response.dart';
import '../repositories/order_repository.dart';

@injectable
class UpdateOrderStatusUseCase {
  final OrderRepository _repository;

  UpdateOrderStatusUseCase(this._repository);

  Future<OrderResponse?> call(int orderId, String status) {
    return _repository.updateOrderStatus(orderId, status);
  }

  Future<OrderResponse?> updatePaymentStatus(
    int orderId,
    String paymentStatus,
  ) {
    return _repository.updatePaymentStatus(orderId, paymentStatus);
  }
}
