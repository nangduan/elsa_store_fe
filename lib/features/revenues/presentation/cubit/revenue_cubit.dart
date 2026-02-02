import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/app_exception.dart';
import '../../data/models/response/revenue_summary_response.dart';
import '../../data/models/response/revenue_timeseries_response.dart';
import '../../data/models/response/revenue_top_product_response.dart';
import '../../domain/entities/revenue_group_by.dart';
import '../../domain/usecases/get_revenue_summary_use_case.dart';
import '../../domain/usecases/get_revenue_timeseries_use_case.dart';
import '../../domain/usecases/get_revenue_top_products_use_case.dart';

enum RevenueStatus { initial, loading, success, failure }

extension RevenueStatusX on RevenueStatus {
  bool get isLoading => this == RevenueStatus.loading;
  bool get isSuccess => this == RevenueStatus.success;
  bool get isFailure => this == RevenueStatus.failure;
  bool get isInitial => this == RevenueStatus.initial;
}

class RevenueState {
  final RevenueStatus status;
  final RevenueSummaryResponse? summary;
  final RevenueTimeseriesResponse? timeseries;
  final List<RevenueTopProductResponse> topProducts;
  final String? errorMessage;

  const RevenueState({
    this.status = RevenueStatus.initial,
    this.summary,
    this.timeseries,
    this.topProducts = const [],
    this.errorMessage,
  });

  RevenueState copyWith({
    RevenueStatus? status,
    RevenueSummaryResponse? summary,
    RevenueTimeseriesResponse? timeseries,
    List<RevenueTopProductResponse>? topProducts,
    String? errorMessage,
  }) {
    return RevenueState(
      status: status ?? this.status,
      summary: summary ?? this.summary,
      timeseries: timeseries ?? this.timeseries,
      topProducts: topProducts ?? this.topProducts,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

@injectable
class RevenueCubit extends Cubit<RevenueState> {
  final GetRevenueSummaryUseCase _getSummary;
  final GetRevenueTimeseriesUseCase _getTimeseries;
  final GetRevenueTopProductsUseCase _getTopProducts;

  RevenueCubit(this._getSummary, this._getTimeseries, this._getTopProducts)
      : super(const RevenueState());

  Future<void> loadSummary({
    required String from,
    required String to,
    required List<int> statuses,
  }) async {
    emit(state.copyWith(status: RevenueStatus.loading));
    try {
      final summary = await _getSummary(
        from: from,
        to: to,
        statuses: statuses,
      );
      emit(state.copyWith(status: RevenueStatus.success, summary: summary));
    } on AppException catch (e) {
      emit(
        state.copyWith(status: RevenueStatus.failure, errorMessage: e.message),
      );
    }
  }

  Future<void> loadTimeseries({
    required String from,
    required String to,
    required RevenueGroupBy groupBy,
    required List<int> statuses,
  }) async {
    emit(state.copyWith(status: RevenueStatus.loading));
    try {
      final timeseries = await _getTimeseries(
        from: from,
        to: to,
        groupBy: groupBy,
        statuses: statuses,
      );
      emit(
        state.copyWith(status: RevenueStatus.success, timeseries: timeseries),
      );
    } on AppException catch (e) {
      emit(
        state.copyWith(status: RevenueStatus.failure, errorMessage: e.message),
      );
    }
  }

  Future<void> loadTopProducts({
    required String from,
    required String to,
    required List<int> statuses,
  }) async {
    emit(state.copyWith(status: RevenueStatus.loading));
    try {
      final items = await _getTopProducts(
        from: from,
        to: to,
        statuses: statuses,
      );
      emit(
        state.copyWith(status: RevenueStatus.success, topProducts: items),
      );
    } on AppException catch (e) {
      emit(
        state.copyWith(status: RevenueStatus.failure, errorMessage: e.message),
      );
    }
  }

  Future<void> loadAll({
    required String from,
    required String to,
    required RevenueGroupBy groupBy,
    required List<int> statuses,
  }) async {
    emit(state.copyWith(status: RevenueStatus.loading));
    try {
      final results = await Future.wait([
        _getSummary(from: from, to: to, statuses: statuses),
        _getTimeseries(
          from: from,
          to: to,
          groupBy: groupBy,
          statuses: statuses,
        ),
        _getTopProducts(from: from, to: to, statuses: statuses),
      ]);

      emit(
        state.copyWith(
          status: RevenueStatus.success,
          summary: results[0] as RevenueSummaryResponse?,
          timeseries: results[1] as RevenueTimeseriesResponse?,
          topProducts: results[2] as List<RevenueTopProductResponse>,
        ),
      );
    } on AppException catch (e) {
      emit(
        state.copyWith(status: RevenueStatus.failure, errorMessage: e.message),
      );
    }
  }
}
