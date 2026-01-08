import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/api/dio_client.dart';
import '../datasource/remote/product_variant_api_service.dart';
import '../models/request/product_variant_request.dart';
import '../../../product/data/models/response/product_variant_response.dart';
import '../../domain/repositories/product_variant_repository.dart';

@LazySingleton(as: ProductVariantRepository)
class ProductVariantRepositoryImpl implements ProductVariantRepository {
  final AdminProductVariantApiService apiService;
  final DioClient dioClient;

  ProductVariantRepositoryImpl(this.apiService, this.dioClient);

  @override
  Future<List<ProductVariantResponse>> getProductVariants(int productId) async {
    try {
      final apiResp = await apiService.getProductVariants(productId);
      final data = apiResp.data;
      if (data is List) {
        return data
            .whereType<Map<String, dynamic>>()
            .map(ProductVariantResponse.fromJson)
            .toList();
      }
      return [];
    } on DioException catch (e) {
      throw dioClient.handleDioError(e);
    }
  }

  @override
  Future<ProductVariantResponse?> createProductVariant(
    ProductVariantRequest request,
  ) async {
    try {
      final apiResp = await apiService.createProductVariant(request);
      final data = apiResp.data;
      if (data is Map<String, dynamic>) {
        return ProductVariantResponse.fromJson(data);
      }
      return null;
    } on DioException catch (e) {
      throw dioClient.handleDioError(e);
    }
  }

  @override
  Future<ProductVariantResponse?> updateProductVariant(
    int id,
    ProductVariantRequest request,
  ) async {
    try {
      final apiResp = await apiService.updateProductVariant(id, request);
      final data = apiResp.data;
      if (data is Map<String, dynamic>) {
        return ProductVariantResponse.fromJson(data);
      }
      return null;
    } on DioException catch (e) {
      throw dioClient.handleDioError(e);
    }
  }

  @override
  Future<void> deleteProductVariant(int id) async {
    try {
      await apiService.deleteProductVariant(id);
    } on DioException catch (e) {
      throw dioClient.handleDioError(e);
    }
  }
}
