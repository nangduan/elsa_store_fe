import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/app_exception.dart';
import '../../data/models/response/product_variant_response.dart';
import '../../domain/usecases/get_product_variants_use_case.dart';

part 'product_variant_state.dart';
part 'product_variant_cubit.freezed.dart';

@injectable
class ProductVariantCubit extends Cubit<ProductVariantState> {
  final GetProductVariantsUseCase _getVariants;

  ProductVariantCubit(this._getVariants) : super(ProductVariantState());

  Future<void> load(int? productId) async {
    if (productId == null) {
      emit(
        state.copyWith(
          status: ProductVariantStatus.failure,
          errorMessage: 'Missing product id',
        ),
      );
      return;
    }

    emit(state.copyWith(status: ProductVariantStatus.loading));
    try {
      final variants = await _getVariants(productId);
      emit(
        state.copyWith(
          status: ProductVariantStatus.success,
          variants: variants,
        ),
      );
    } on AppException catch (e) {
      emit(
        state.copyWith(
          status: ProductVariantStatus.failure,
          errorMessage: e.message,
        ),
      );
    }
  }
}
