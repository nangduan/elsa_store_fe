import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/app_exception.dart';
import '../../data/models/response/product_detail_response.dart';
import '../../domain/usecases/get_product_detail_use_case.dart';

enum ProductDetailStatus { initial, loading, success, failure }

class ProductDetailState {
  final ProductDetailStatus status;
  final ProductDetailResponse? product;
  final String? errorMessage;

  const ProductDetailState({
    this.status = ProductDetailStatus.initial,
    this.product,
    this.errorMessage,
  });

  ProductDetailState copyWith({
    ProductDetailStatus? status,
    ProductDetailResponse? product,
    String? errorMessage,
  }) {
    return ProductDetailState(
      status: status ?? this.status,
      product: product ?? this.product,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

@injectable
class ProductDetailCubit extends Cubit<ProductDetailState> {
  final GetProductDetailUseCase _getProductDetail;

  ProductDetailCubit(this._getProductDetail) : super(const ProductDetailState());

  Future<void> load(int? productId) async {
    if (productId == null) {
      emit(
        state.copyWith(
          status: ProductDetailStatus.failure,
          errorMessage: 'Missing product id',
        ),
      );
      return;
    }

    emit(state.copyWith(status: ProductDetailStatus.loading));
    try {
      final detail = await _getProductDetail(productId);
      if (detail == null) {
        emit(
          state.copyWith(
            status: ProductDetailStatus.failure,
            errorMessage: 'Product not found',
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          status: ProductDetailStatus.success,
          product: detail,
        ),
      );
    } on AppException catch (e) {
      emit(
        state.copyWith(
          status: ProductDetailStatus.failure,
          errorMessage: e.message,
        ),
      );
    }
  }
}
