import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../../core/shared/data/models/api_response.dart';
import '../../models/request/category_request.dart';

part 'category_api_service.g.dart';

@RestApi()
abstract class CategoryApiService {
  factory CategoryApiService(Dio dio, {String? baseUrl}) =
      _CategoryApiService;

  @GET('/categories')
  Future<ApiResponse> getCategories();

  @POST('/categories')
  Future<ApiResponse> createCategory(@Body() CategoryRequest body);

  @PUT('/categories/{id}')
  Future<ApiResponse> updateCategory(
    @Path('id') int id,
    @Body() CategoryRequest body,
  );

  @DELETE('/categories/{id}')
  Future<ApiResponse> deleteCategory(@Path('id') int id);
}
