import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/api/dio_client.dart';
import '../datasource/remote/category_api_service.dart';
import '../models/request/category_request.dart';
import '../models/response/category_response.dart';
import '../../domain/repositories/category_repository.dart';

@LazySingleton(as: CategoryRepository)
class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryApiService apiService;
  final DioClient dioClient;

  CategoryRepositoryImpl(this.apiService, this.dioClient);

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
  Future<CategoryResponse?> createCategory(CategoryRequest request) async {
    try {
      final apiResp = await apiService.createCategory(request);
      final data = apiResp.data;
      if (data is Map<String, dynamic>) {
        return CategoryResponse.fromJson(data);
      }
      return null;
    } on DioException catch (e) {
      throw dioClient.handleDioError(e);
    }
  }

  @override
  Future<CategoryResponse?> updateCategory(
    int id,
    CategoryRequest request,
  ) async {
    try {
      final apiResp = await apiService.updateCategory(id, request);
      final data = apiResp.data;
      if (data is Map<String, dynamic>) {
        return CategoryResponse.fromJson(data);
      }
      return null;
    } on DioException catch (e) {
      throw dioClient.handleDioError(e);
    }
  }

  @override
  Future<void> deleteCategory(int id) async {
    try {
      await apiService.deleteCategory(id);
    } on DioException catch (e) {
      throw dioClient.handleDioError(e);
    }
  }
}
