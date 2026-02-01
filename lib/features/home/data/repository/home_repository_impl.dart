import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/api/dio_client.dart';
import '../datasource/remote/home_api_service.dart';
import '../models/response/category_response.dart';
import '../models/response/product_response.dart';
import '../../domain/repositories/home_repository.dart';

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
}
