import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../../core/shared/data/models/api_response.dart';
import '../../../../product/data/models/request/search_request.dart';

part 'home_api_service.g.dart';

@RestApi()
abstract class HomeApiService {
  factory HomeApiService(Dio dio, {String? baseUrl}) = _HomeApiService;

  @GET('/categories')
  Future<ApiResponse> getCategories();

  @GET('/products')
  Future<ApiResponse> getProducts({@Query('categoryId') int? categoryId});

  @POST('/products/search')
  Future<ApiResponse> searchProducts(@Body() SearchProductRequest request);
}
