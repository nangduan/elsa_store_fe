import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/api/dio_client.dart';
import '../datasource/remote/home_api_service.dart';
import '../models/response/category_response.dart';
import '../models/response/product_response.dart';
import '../../domain/repositories/home_repository.dart';
import '../../../product/data/models/request/search_request.dart';

@LazySingleton(as: HomeRepository)
class HomeRepositoryImpl implements HomeRepository {
  final HomeApiService apiService;
  final DioClient dioClient;

  HomeRepositoryImpl(this.apiService, this.dioClient);

  @override
  Future<List<CategoryResponse>> getCategories() async {
    try {
      final apiResp = await apiService.getCategories();
      final data = apiResp.data;

      if (data is List) {
        return data
            .whereType<Map<String, dynamic>>()
            .map(CategoryResponse.fromJson)
            .toList();
      }

      return [];
    } on DioException catch (e) {
      throw dioClient.handleDioError(e);
    }
  }

  @override
  Future<List<ProductResponse>> getProducts({int? categoryId}) async {
    try {
      final apiResp = await apiService.getProducts(categoryId: categoryId);
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
  Future<List<ProductResponse>> searchProducts(
    SearchProductRequest request,
  ) async {
    try {
      final apiResp = await apiService.searchProducts(request);
      final data = apiResp.data;

      if (data is List) {
        return data
            .whereType<Map<String, dynamic>>()
            .map(ProductResponse.fromJson)
            .toList();
      }

      if (data is Map<String, dynamic>) {
        final candidates = [
          data['content'],
          data['items'],
          data['results'],
          data['data'],
          data['records'],
        ];

        for (final candidate in candidates) {
          if (candidate is List) {
            return candidate
                .whereType<Map<String, dynamic>>()
                .map(ProductResponse.fromJson)
                .toList();
          }
        }
      }

      return [];
    } on DioException catch (e) {
      throw dioClient.handleDioError(e);
    }
  }
}
