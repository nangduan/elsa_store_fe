import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/api/dio_client.dart';
import '../datasource/remote/order_api_service.dart';
import '../models/request/create_order_item_request.dart';
import '../models/request/create_order_request.dart';
import '../models/response/order_response.dart';
import '../../domain/repositories/order_repository.dart';

@LazySingleton(as: OrderRepository)
class OrderRepositoryImpl implements OrderRepository {
  final OrderApiService apiService;
  final DioClient dioClient;

  OrderRepositoryImpl(this.apiService, this.dioClient);

  @override
  Future<List<OrderResponse>> getAllOrder() async {
    try {
      final apiResp = await apiService.getAllOrder();
      final data = apiResp.data;
      if (data is List) {
        return data
            .whereType<Map<String, dynamic>>()
            .map(OrderResponse.fromJson)
            .toList();
      }
      return const [];
    } on DioException catch (e) {
      throw dioClient.handleDioError(e);
    }
  }

  @override
  Future<List<OrderResponse>> getAllOrderByUser(int userId) async {
    try {
      final apiResp = await apiService.getAllOrderByUser(userId);
      final data = apiResp.data;
      if (data is List) {
        return data
            .whereType<Map<String, dynamic>>()
            .map(OrderResponse.fromJson)
            .toList();
      }
      return const [];
    } on DioException catch (e) {
      throw dioClient.handleDioError(e);
    }
  }

  @override
  Future<OrderResponse?> createOrder(
    int userId,
    List<CreateOrderItemRequest> items,
    int paymentMethod,
  ) async {
    try {
      final apiResp = await apiService.createOrder(
        CreateOrderRequest(
          userId: userId,
          items: items,
          paymentMethod: paymentMethod,
        ),
      );
      final data = apiResp.data;
      if (data is Map<String, dynamic>) {
        return OrderResponse.fromJson(data);
      }
      return null;
    } on DioException catch (e) {
      throw dioClient.handleDioError(e);
    }
  }

  @override
  Future<OrderResponse?> updateOrderStatus(int orderId, String status) async {
    return _updateOrderAndPaymentStatus(orderId, status: status);
  }

  @override
  Future<OrderResponse?> updatePaymentStatus(
    int orderId,
    String paymentStatus,
  ) async {
    return _updateOrderAndPaymentStatus(orderId, paymentStatus: paymentStatus);
  }

  Future<OrderResponse?> _updateOrderAndPaymentStatus(
    int orderId, {
    String? status,
    String? paymentStatus,
  }) async {
    try {
      final response = await dioClient.dio.put(
        '/orders/$orderId/status',
        queryParameters: {
          if (status != null) 'status': status,
          if (paymentStatus != null) 'paymentStatus': paymentStatus,
        },
      );
      final data = response.data;
      if (data is Map<String, dynamic>) {
        final payload = data['data'];
        if (payload is Map<String, dynamic>) {
          return OrderResponse.fromJson(payload);
        }
        return OrderResponse.fromJson(data);
      }
      return null;
    } on DioException catch (e) {
      throw dioClient.handleDioError(e);
    }
  }
}
