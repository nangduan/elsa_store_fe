import 'package:injectable/injectable.dart';

import '../../data/models/response/revenue_timeseries_response.dart';
import '../entities/revenue_group_by.dart';
import '../repositories/revenue_repository.dart';

@injectable
class GetRevenueTimeseriesUseCase {
  final RevenueRepository _repository;

  GetRevenueTimeseriesUseCase(this._repository);

  Future<RevenueTimeseriesResponse?> call({
    required String from,
    required String to,
    required RevenueGroupBy groupBy,
    required List<int> statuses,
  }) {
    return _repository.getTimeseries(
      from: from,
      to: to,
      groupBy: groupBy,
      statuses: statuses,
    );
  }
}
