part of 'product_variant_cubit.dart';

enum ProductVariantStatus { initial, loading, success, failure }

extension ProductVariantStatusX on ProductVariantStatus {
  bool get isLoading => this == ProductVariantStatus.loading;
  bool get isSuccess => this == ProductVariantStatus.success;
  bool get isFailure => this == ProductVariantStatus.failure;
  bool get isInitial => this == ProductVariantStatus.initial;
}

@freezed
class ProductVariantState with _$ProductVariantState {
  const factory ProductVariantState({
    @Default(ProductVariantStatus.initial) ProductVariantStatus status,
    @Default([]) List<ProductVariantResponse> variants,
    String? errorMessage,
  }) = _Initial;
}
