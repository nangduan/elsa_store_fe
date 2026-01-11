import 'package:dio/dio.dart';

import '../../../../../core/shared/data/models/api_response.dart';
import '../../models/request/product_variant_request.dart';

class AdminProductVariantApiService {
  final Dio _dio;

  AdminProductVariantApiService(this._dio);

  Future<ApiResponse> getProductVariants(int productId) async {
    final response = await _dio.get(
      '/product-variants',
      queryParameters: {'productId': productId},
    );
    return _wrapResponse(response);
  }

  Future<ApiResponse> createProductVariant(ProductVariantRequest body) async {
    final response = await _dio.post('/product-variants', data: body.toJson());
    return _wrapResponse(response);
  }

  Future<ApiResponse> updateProductVariant(
    int id,
    ProductVariantRequest body,
  ) async {
    final response = await _dio.put('/product-variants/$id', data: body.toJson());
    return _wrapResponse(response);
  }

  Future<void> deleteProductVariant(int id) async {
    await _dio.delete('/product-variants/$id');
  }

  ApiResponse _wrapResponse(Response response) {
    final data = response.data;
    if (data is Map<String, dynamic>) {
      return ApiResponse.fromJson(data);
    }
    return ApiResponse(data: data);
  }
}
