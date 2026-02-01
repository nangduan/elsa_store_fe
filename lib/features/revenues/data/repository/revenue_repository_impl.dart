import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/api/dio_client.dart';
import '../datasource/remote/revenue_api_service.dart';
import '../models/response/revenue_summary_response.dart';
import '../models/response/revenue_timeseries_response.dart';
import '../models/response/revenue_top_product_response.dart';
import '../../domain/entities/revenue_group_by.dart';
import '../../domain/repositories/revenue_repository.dart';

@LazySingleton(as: RevenueRepository)
class RevenueRepositoryImpl implements RevenueRepository {
  final RevenueApiService apiService;
  final DioClient dioClient;

  RevenueRepositoryImpl(this.apiService, this.dioClient);

  @override
  Future<RevenueSummaryResponse?> getSummary({
    required String from,
    required String to,
    required List<int> statuses,
  }) async {
    try {
      final apiResp = await apiService.getSummary(
        from: from,
        to: to,
        statuses: _joinStatuses(statuses),
      );
      final data = apiResp.data;
      if (data is Map<String, dynamic>) {
        return RevenueSummaryResponse.fromJson(data);
      }
      return null;
    } on DioException catch (e) {
      throw dioClient.handleDioError(e);
    }
  }

  @override
  Future<RevenueTimeseriesResponse?> getTimeseries({
    required String from,
    required String to,
    required RevenueGroupBy groupBy,
    required List<int> statuses,
  }) async {
    try {
      final apiResp = await apiService.getTimeseries(
        from: from,
        to: to,
        groupBy: groupBy.apiValue,
        statuses: _joinStatuses(statuses),
      );
      final data = apiResp.data;
      if (data is Map<String, dynamic>) {
        return RevenueTimeseriesResponse.fromJson(data);
      }
      return null;
    } on DioException catch (e) {
      throw dioClient.handleDioError(e);
    }
  }

  @override
  Future<List<RevenueTopProductResponse>> getTopProducts({
    required String from,
    required String to,
    required List<int> statuses,
  }) async {
    try {
      final apiResp = await apiService.getTopProducts(
        from: from,
        to: to,
        statuses: _joinStatuses(statuses),
      );
      final data = apiResp.data;
      if (data is List) {
        return data
            .whereType<Map<String, dynamic>>()
            .map(RevenueTopProductResponse.fromJson)
            .toList();
      }
      return const [];
    } on DioException catch (e) {
      throw dioClient.handleDioError(e);
    }
  }

  String _joinStatuses(List<int> statuses) {
    return statuses.join(',');
  }
}
