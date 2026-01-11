import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/api/dio_client.dart';
import '../datasource/remote/cart_api_service.dart';
import '../models/request/add_cart_item_request.dart';
import '../models/request/update_cart_item_request.dart';
import '../models/response/cart_response.dart';
import '../../domain/repositories/cart_repository.dart';

@LazySingleton(as: CartRepository)
class CartRepositoryImpl implements CartRepository {
  final CartApiService apiService;
  final DioClient dioClient;

  CartRepositoryImpl(this.apiService, this.dioClient);

  @override
  Future<CartResponse?> getCart(int userId) async {
    try {
      final apiResp = await apiService.getCart(userId);
      final data = apiResp.data;
      if (data is Map<String, dynamic>) {
        return CartResponse.fromJson(data);
      }
      return null;
    } on DioException catch (e) {
      throw dioClient.handleDioError(e);
    }
  }

  @override
  Future<CartResponse?> addItem(
    int userId,
    int productVariantId,
    int quantity,
  ) async {
    try {
      final apiResp = await apiService.addItem(
        userId,
        AddCartItemRequest(
          productVariantId: productVariantId,
          quantity: quantity,
        ),
      );
      final data = apiResp.data;
      if (data is Map<String, dynamic>) {
        return CartResponse.fromJson(data);
      }
      return null;
    } on DioException catch (e) {
      throw dioClient.handleDioError(e);
    }
  }

  @override
  Future<CartResponse?> updateItemQuantity(
    int userId,
    int itemId,
    int quantity,
  ) async {
    try {
      final apiResp = await apiService.updateItemQuantity(
        itemId,
        userId,
        UpdateCartItemRequest(quantity: quantity),
      );
      final data = apiResp.data;
      if (data is Map<String, dynamic>) {
        return CartResponse.fromJson(data);
      }
      return null;
    } on DioException catch (e) {
      throw dioClient.handleDioError(e);
    }
  }

  @override
  Future<CartResponse?> deleteItem(int userId, int itemId) async {
    try {
      final apiResp = await apiService.deleteItem(itemId, userId);
      final data = apiResp.data;
      if (data is Map<String, dynamic>) {
        return CartResponse.fromJson(data);
      }
      return null;
    } on DioException catch (e) {
      throw dioClient.handleDioError(e);
    }
  }
}
