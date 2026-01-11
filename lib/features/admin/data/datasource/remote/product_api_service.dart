import 'package:dio/dio.dart';

import '../../../../../core/shared/data/models/api_response.dart';
import '../../models/request/product_request.dart';

class AdminProductApiService {
  final Dio _dio;

  AdminProductApiService(this._dio);

  Future<ApiResponse> getProducts() async {
    final response = await _dio.get('/products');
    return _wrapResponse(response);
  }

  Future<ApiResponse> createProduct(ProductRequest body) async {
    final response = await _dio.post('/products', data: body.toJson());
    return _wrapResponse(response);
  }

  Future<ApiResponse> updateProduct(int id, ProductRequest body) async {
    final response = await _dio.put('/products/$id', data: body.toJson());
    return _wrapResponse(response);
  }

  Future<void> deleteProduct(int id) async {
    await _dio.delete('/products/$id');
  }

  ApiResponse _wrapResponse(Response response) {
    final data = response.data;
    if (data is Map<String, dynamic>) {
      return ApiResponse.fromJson(data);
    }
    return ApiResponse(data: data);
  }
}
