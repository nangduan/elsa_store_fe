import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/api/dio_client.dart';
import '../datasource/remote/promotion_api_service.dart';
import '../models/request/promotion_request.dart';
import '../models/response/promotion_response.dart';
import '../../domain/repositories/promotion_repository.dart';

@LazySingleton(as: PromotionRepository)
class PromotionRepositoryImpl implements PromotionRepository {
  final AdminPromotionApiService apiService;
  final DioClient dioClient;

  PromotionRepositoryImpl(this.apiService, this.dioClient);

  @override
  Future<List<PromotionResponse>> getPromotions() async {
    try {
      final apiResp = await apiService.getPromotions();
      final data = apiResp.data;
      if (data is List) {
        return data
            .whereType<Map<String, dynamic>>()
            .map(PromotionResponse.fromJson)
            .toList();
      }
      return [];
    } on DioException catch (e) {
      throw dioClient.handleDioError(e);
    }
  }

  @override
  Future<PromotionResponse?> createPromotion(PromotionRequest request) async {
    try {
      final apiResp = await apiService.createPromotion(request);
      final data = apiResp.data;
      if (data is Map<String, dynamic>) {
        return PromotionResponse.fromJson(data);
      }
      return null;
    } on DioException catch (e) {
      throw dioClient.handleDioError(e);
    }
  }

  @override
  Future<PromotionResponse?> updatePromotion(
    int id,
    PromotionRequest request,
  ) async {
    try {
      final apiResp = await apiService.updatePromotion(id, request);
      final data = apiResp.data;
      if (data is Map<String, dynamic>) {
        return PromotionResponse.fromJson(data);
      }
      return null;
    } on DioException catch (e) {
      throw dioClient.handleDioError(e);
    }
  }

  @override
  Future<void> deletePromotion(int id) async {
    try {
      await apiService.deletePromotion(id);
    } on DioException catch (e) {
      throw dioClient.handleDioError(e);
    }
  }
}
