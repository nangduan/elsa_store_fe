import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/app_exception.dart';
import '../../data/models/request/product_variant_request.dart';
import '../../../product/data/models/response/product_variant_response.dart';
import '../../domain/usecases/create_product_variant_use_case.dart';
import '../../domain/usecases/delete_product_variant_use_case.dart';
import '../../domain/usecases/get_admin_product_variants_use_case.dart';
import '../../domain/usecases/update_product_variant_use_case.dart';

enum AdminProductVariantStatus { initial, loading, success, failure }

extension AdminProductVariantStatusX on AdminProductVariantStatus {
  bool get isLoading => this == AdminProductVariantStatus.loading;
  bool get isSuccess => this == AdminProductVariantStatus.success;
  bool get isFailure => this == AdminProductVariantStatus.failure;
  bool get isInitial => this == AdminProductVariantStatus.initial;
}

class AdminProductVariantState {
  final AdminProductVariantStatus status;
  final List<ProductVariantResponse> variants;
  final String? errorMessage;

  const AdminProductVariantState({
    this.status = AdminProductVariantStatus.initial,
    this.variants = const [],
    this.errorMessage,
  });

  AdminProductVariantState copyWith({
    AdminProductVariantStatus? status,
    List<ProductVariantResponse>? variants,
    String? errorMessage,
  }) {
    return AdminProductVariantState(
      status: status ?? this.status,
      variants: variants ?? this.variants,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

@injectable
class AdminProductVariantCubit extends Cubit<AdminProductVariantState> {
  final GetAdminProductVariantsUseCase _getVariants;
  final CreateProductVariantUseCase _createVariant;
  final UpdateProductVariantUseCase _updateVariant;
  final DeleteProductVariantUseCase _deleteVariant;
  int? _productId;

  AdminProductVariantCubit(
    this._getVariants,
    this._createVariant,
    this._updateVariant,
    this._deleteVariant,
  ) : super(const AdminProductVariantState());

  Future<void> load(int? productId) async {
    if (productId == null) {
      emit(
        state.copyWith(
          status: AdminProductVariantStatus.failure,
          errorMessage: 'Missing product id',
        ),
      );
      return;
    }

    _productId = productId;
    emit(state.copyWith(status: AdminProductVariantStatus.loading));
    try {
      final variants = await _getVariants(productId);
      emit(
        state.copyWith(
          status: AdminProductVariantStatus.success,
          variants: variants,
        ),
      );
    } on AppException catch (e) {
      emit(
        state.copyWith(
          status: AdminProductVariantStatus.failure,
          errorMessage: e.message,
        ),
      );
    }
  }

  Future<void> create(ProductVariantRequest request) async {
    emit(state.copyWith(status: AdminProductVariantStatus.loading));
    try {
      await _createVariant(request);
      await load(_productId);
    } on AppException catch (e) {
      emit(
        state.copyWith(
          status: AdminProductVariantStatus.failure,
          errorMessage: e.message,
        ),
      );
    }
  }

  Future<void> update(int id, ProductVariantRequest request) async {
    emit(state.copyWith(status: AdminProductVariantStatus.loading));
    try {
      await _updateVariant(id, request);
      await load(_productId);
    } on AppException catch (e) {
      emit(
        state.copyWith(
          status: AdminProductVariantStatus.failure,
          errorMessage: e.message,
        ),
      );
    }
  }

  Future<void> remove(int id) async {
    emit(state.copyWith(status: AdminProductVariantStatus.loading));
    try {
      await _deleteVariant(id);
      await load(_productId);
    } on AppException catch (e) {
      emit(
        state.copyWith(
          status: AdminProductVariantStatus.failure,
          errorMessage: e.message,
        ),
      );
    }
  }
}
