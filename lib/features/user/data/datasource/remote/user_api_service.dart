import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../../core/shared/data/models/api_response.dart';

part 'user_api_service.g.dart';

@RestApi()
abstract class UserApiService {
  factory UserApiService(Dio dio, {String? baseUrl}) = _UserApiService;

  @GET('/users/{id}')
  Future<ApiResponse> getUserById(@Path('id') int id);

  @PUT('/users/{id}')
  Future<ApiResponse> updateUser(
    @Path('id') int id,
    @Body() Map<String, dynamic> body,
  );
}
