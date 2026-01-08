import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/app_exception.dart';
import '../../data/models/request/promotion_request.dart';
import '../../data/models/response/promotion_response.dart';
import '../../domain/usecases/create_promotion_use_case.dart';
import '../../domain/usecases/delete_promotion_use_case.dart';
import '../../domain/usecases/get_promotions_use_case.dart';
import '../../domain/usecases/update_promotion_use_case.dart';

enum PromotionStatus { initial, loading, success, failure }

extension PromotionStatusX on PromotionStatus {
  bool get isLoading => this == PromotionStatus.loading;
  bool get isSuccess => this == PromotionStatus.success;
  bool get isFailure => this == PromotionStatus.failure;
  bool get isInitial => this == PromotionStatus.initial;
}

class PromotionState {
  final PromotionStatus status;
  final List<PromotionResponse> promotions;
  final String? errorMessage;

  const PromotionState({
    this.status = PromotionStatus.initial,
    this.promotions = const [],
    this.errorMessage,
  });

  PromotionState copyWith({
    PromotionStatus? status,
    List<PromotionResponse>? promotions,
    String? errorMessage,
  }) {
    return PromotionState(
      status: status ?? this.status,
      promotions: promotions ?? this.promotions,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

@injectable
class PromotionCubit extends Cubit<PromotionState> {
  final GetPromotionsUseCase _getPromotions;
  final CreatePromotionUseCase _createPromotion;
  final UpdatePromotionUseCase _updatePromotion;
  final DeletePromotionUseCase _deletePromotion;

  PromotionCubit(
    this._getPromotions,
    this._createPromotion,
    this._updatePromotion,
    this._deletePromotion,
  ) : super(const PromotionState());

  Future<void> load() async {
    emit(state.copyWith(status: PromotionStatus.loading));
    try {
      final items = await _getPromotions();
      emit(state.copyWith(status: PromotionStatus.success, promotions: items));
    } on AppException catch (e) {
      emit(state.copyWith(status: PromotionStatus.failure, errorMessage: e.message));
    }
  }

  Future<void> create(PromotionRequest request) async {
    emit(state.copyWith(status: PromotionStatus.loading));
    try {
      await _createPromotion(request);
      await load();
    } on AppException catch (e) {
      emit(state.copyWith(status: PromotionStatus.failure, errorMessage: e.message));
    }
  }

  Future<void> update(int id, PromotionRequest request) async {
    emit(state.copyWith(status: PromotionStatus.loading));
    try {
      await _updatePromotion(id, request);
      await load();
    } on AppException catch (e) {
      emit(state.copyWith(status: PromotionStatus.failure, errorMessage: e.message));
    }
  }

  Future<void> remove(int id) async {
    emit(state.copyWith(status: PromotionStatus.loading));
    try {
      await _deletePromotion(id);
      await load();
    } on AppException catch (e) {
      emit(state.copyWith(status: PromotionStatus.failure, errorMessage: e.message));
    }
  }
}
