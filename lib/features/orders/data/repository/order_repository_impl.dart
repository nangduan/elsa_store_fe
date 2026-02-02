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
  ) async {
    try {
      final apiResp = await apiService.createOrder(
        CreateOrderRequest(userId: userId, items: items),
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
}
