import 'package:injectable/injectable.dart';

import '../../data/models/response/revenue_summary_response.dart';
import '../repositories/revenue_repository.dart';

@injectable
class GetRevenueSummaryUseCase {
  final RevenueRepository _repository;

  GetRevenueSummaryUseCase(this._repository);

  Future<RevenueSummaryResponse?> call({
    required String from,
    required String to,
    required List<int> statuses,
  }) {
    return _repository.getSummary(from: from, to: to, statuses: statuses);
  }
}
