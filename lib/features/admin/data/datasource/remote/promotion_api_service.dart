import 'package:dio/dio.dart';

import '../../../../../core/shared/data/models/api_response.dart';
import '../../models/request/promotion_request.dart';

class AdminPromotionApiService {
  final Dio _dio;

  AdminPromotionApiService(this._dio);

  Future<ApiResponse> getPromotions() async {
    final response = await _dio.get('/promotions');
    return _wrapResponse(response);
  }

  Future<ApiResponse> createPromotion(PromotionRequest body) async {
    final response = await _dio.post('/promotions', data: body.toJson());
    return _wrapResponse(response);
  }

  Future<ApiResponse> updatePromotion(int id, PromotionRequest body) async {
    final response = await _dio.put('/promotions/$id', data: body.toJson());
    return _wrapResponse(response);
  }

  Future<void> deletePromotion(int id) async {
    await _dio.delete('/promotions/$id');
  }

  ApiResponse _wrapResponse(Response response) {
    final data = response.data;
    if (data is Map<String, dynamic>) {
      return ApiResponse.fromJson(data);
    }
    return ApiResponse(data: data);
  }
}
