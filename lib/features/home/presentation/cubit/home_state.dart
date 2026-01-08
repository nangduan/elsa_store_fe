part of 'home_cubit.dart';

enum HomeStatus { initial, loading, success, failure }

extension HomeStatusX on HomeStatus {
  bool get isLoading => this == HomeStatus.loading;
  bool get isSuccess => this == HomeStatus.success;
  bool get isFailure => this == HomeStatus.failure;
  bool get isInitial => this == HomeStatus.initial;
}

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    @Default(HomeStatus.initial) HomeStatus status,
    @Default([]) List<CategoryResponse> categories,
    @Default([]) List<ProductResponse> products,
    String? errorMessage,
  }) = _Initial;
}
