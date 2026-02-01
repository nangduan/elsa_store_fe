import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../../core/shared/data/models/api_response.dart';

part 'revenue_api_service.g.dart';

@RestApi()
abstract class RevenueApiService {
  factory RevenueApiService(Dio dio, {String? baseUrl}) = _RevenueApiService;

  @GET('/revenues/summary')
  Future<ApiResponse> getSummary({
    @Query('from') required String from,
    @Query('to') required String to,
    @Query('statuses') required String statuses,
  });

  @GET('/revenues/timeseries')
  Future<ApiResponse> getTimeseries({
    @Query('from') required String from,
    @Query('to') required String to,
    @Query('groupBy') required String groupBy,
    @Query('statuses') required String statuses,
  });

  @GET('/revenues/top-products')
  Future<ApiResponse> getTopProducts({
    @Query('from') required String from,
    @Query('to') required String to,
    @Query('statuses') required String statuses,
  });
}
