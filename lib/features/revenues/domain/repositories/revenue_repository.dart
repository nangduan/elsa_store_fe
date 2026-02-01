import '../../data/models/response/revenue_summary_response.dart';
import '../../data/models/response/revenue_timeseries_response.dart';
import '../../data/models/response/revenue_top_product_response.dart';
import '../entities/revenue_group_by.dart';

abstract class RevenueRepository {
  Future<RevenueSummaryResponse?> getSummary({
    required String from,
    required String to,
    required List<int> statuses,
  });

  Future<RevenueTimeseriesResponse?> getTimeseries({
    required String from,
    required String to,
    required RevenueGroupBy groupBy,
    required List<int> statuses,
  });

  Future<List<RevenueTopProductResponse>> getTopProducts({
    required String from,
    required String to,
    required List<int> statuses,
  });
}
