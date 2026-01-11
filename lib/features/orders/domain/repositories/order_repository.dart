import '../../data/models/request/create_order_item_request.dart';
import '../../data/models/response/order_response.dart';

abstract class OrderRepository {
  Future<List<OrderResponse>> getOrders(int userId);
  Future<OrderResponse?> createOrder(
    int userId,
    List<CreateOrderItemRequest> items,
  );
}
