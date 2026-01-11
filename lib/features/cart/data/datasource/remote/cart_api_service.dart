import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../../core/shared/data/models/api_response.dart';
import '../../models/request/add_cart_item_request.dart';
import '../../models/request/update_cart_item_request.dart';

part 'cart_api_service.g.dart';

@RestApi()
abstract class CartApiService {
  factory CartApiService(Dio dio, {String? baseUrl}) = _CartApiService;

  @GET('/cart')
  Future<ApiResponse> getCart(@Query('userId') int userId);

  @POST('/cart/items')
  Future<ApiResponse> addItem(
    @Query('userId') int userId,
    @Body() AddCartItemRequest body,
  );

  @PUT('/cart/items/{id}')
  Future<ApiResponse> updateItemQuantity(
    @Path('id') int itemId,
    @Query('userId') int userId,
    @Body() UpdateCartItemRequest body,
  );

  @DELETE('/cart/items/{id}')
  Future<ApiResponse> deleteItem(
    @Path('id') int itemId,
    @Query('userId') int userId,
  );
}
