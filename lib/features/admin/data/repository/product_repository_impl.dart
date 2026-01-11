import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/api/dio_client.dart';
import '../datasource/remote/product_api_service.dart';
import '../models/request/product_request.dart';
import '../models/response/product_response.dart';
import '../../domain/repositories/product_repository.dart';

@LazySingleton(as: ProductRepository)
class ProductRepositoryImpl implements ProductRepository {
  final AdminProductApiService apiService;
  final DioClient dioClient;

  ProductRepositoryImpl(this.apiService, this.dioClient);

  @override
  Future<List<ProductResponse>> getProducts() async {
    try {
      final apiResp = await apiService.getProducts();
      final data = apiResp.data;
      if (data is List) {
        return data
            .whereType<Map<String, dynamic>>()
            .map(ProductResponse.fromJson)
            .toList();
      }
      return [];
    } on DioException catch (e) {
      throw dioClient.handleDioError(e);
    }
  }

  @override
  Future<ProductResponse?> createProduct(ProductRequest request) async {
    try {
      final apiResp = await apiService.createProduct(request);
      final data = apiResp.data;
      if (data is Map<String, dynamic>) {
        return ProductResponse.fromJson(data);
      }
      return null;
    } on DioException catch (e) {
      throw dioClient.handleDioError(e);
    }
  }

  @override
  Future<ProductResponse?> updateProduct(
    int id,
    ProductRequest request,
  ) async {
    try {
      final apiResp = await apiService.updateProduct(id, request);
      final data = apiResp.data;
      if (data is Map<String, dynamic>) {
        return ProductResponse.fromJson(data);
      }
      return null;
    } on DioException catch (e) {
      throw dioClient.handleDioError(e);
    }
  }

  @override
  Future<void> deleteProduct(int id) async {
    try {
      await apiService.deleteProduct(id);
    } on DioException catch (e) {
      throw dioClient.handleDioError(e);
    }
  }
}
