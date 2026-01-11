part of 'category_cubit.dart';

enum CategoryStatus { initial, loading, success, failure }

extension CategoryStatusX on CategoryStatus {
  bool get isLoading => this == CategoryStatus.loading;
  bool get isSuccess => this == CategoryStatus.success;
  bool get isFailure => this == CategoryStatus.failure;
  bool get isInitial => this == CategoryStatus.initial;
}

@freezed
class CategoryState with _$CategoryState {
  const factory CategoryState({
    @Default(CategoryStatus.initial) CategoryStatus status,
    @Default([]) List<CategoryResponse> categories,
    String? errorMessage,
  }) = _Initial;
}
