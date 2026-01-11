import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../../core/shared/data/models/api_response.dart';
import '../../models/request/create_order_request.dart';

part 'order_api_service.g.dart';

@RestApi()
abstract class OrderApiService {
  factory OrderApiService(Dio dio, {String? baseUrl}) = _OrderApiService;

  @GET('/orders')
  Future<ApiResponse> getOrders(@Query('userId') int userId);

  @POST('/orders')
  Future<ApiResponse> createOrder(@Body() CreateOrderRequest body);
}
