import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/api/dio_client.dart';
import '../datasource/remote/product_api_service.dart';
import '../models/response/product_variant_response.dart';
import '../../domain/repositories/product_repository.dart';

@LazySingleton(as: ProductRepository)
class ProductRepositoryImpl implements ProductRepository {
  final ProductApiService apiService;
  final DioClient dioClient;

  ProductRepositoryImpl(this.apiService, this.dioClient);

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
}
