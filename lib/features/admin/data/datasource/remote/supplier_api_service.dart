import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../../core/shared/data/models/api_response.dart';
import '../../models/request/supplier_request.dart';

part 'supplier_api_service.g.dart';

@RestApi()
abstract class SupplierApiService {
  factory SupplierApiService(Dio dio, {String? baseUrl}) =
      _SupplierApiService;

  @GET('/suppliers')
  Future<ApiResponse> getSuppliers();

  @POST('/suppliers')
  Future<ApiResponse> createSupplier(@Body() SupplierRequest body);

  @PUT('/suppliers/{id}')
  Future<ApiResponse> updateSupplier(
    @Path('id') int id,
    @Body() SupplierRequest body,
  );

  @DELETE('/suppliers/{id}')
  Future<ApiResponse> deleteSupplier(@Path('id') int id);
}
