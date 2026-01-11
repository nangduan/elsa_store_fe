import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../../core/shared/data/models/api_response.dart';

part 'product_api_service.g.dart';

@RestApi()
abstract class ProductApiService {
  factory ProductApiService(Dio dio, {String? baseUrl}) = _ProductApiService;

  @GET('/products/{id}')
  Future<ApiResponse> getProductDetail(@Path('id') int id);

  @GET('/product-variants')
  Future<ApiResponse> getProductVariants(@Query('productId') int productId);
}
