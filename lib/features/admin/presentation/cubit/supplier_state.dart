part of 'supplier_cubit.dart';

enum SupplierStatus { initial, loading, success, failure }

extension SupplierStatusX on SupplierStatus {
  bool get isLoading => this == SupplierStatus.loading;
  bool get isSuccess => this == SupplierStatus.success;
  bool get isFailure => this == SupplierStatus.failure;
  bool get isInitial => this == SupplierStatus.initial;
}

@freezed
class SupplierState with _$SupplierState {
  const factory SupplierState({
    @Default(SupplierStatus.initial) SupplierStatus status,
    @Default([]) List<SupplierResponse> suppliers,
    String? errorMessage,
  }) = _Initial;
}
