import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/app_exception.dart';
import '../../data/models/response/category_response.dart';
import '../../data/models/response/product_response.dart';
import '../../domain/usecases/get_categories_use_case.dart';
import '../../domain/usecases/get_products_use_case.dart';

part 'home_state.dart';
part 'home_cubit.freezed.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final GetCategoriesUseCase _getCategories;
  final GetProductsUseCase _getProducts;

  HomeCubit(this._getCategories, this._getProducts) : super(HomeState());

  Future<void> load() async {
    emit(state.copyWith(status: HomeStatus.loading));
    try {
      final categories = await _getCategories();
      final products = await _getProducts();
      emit(
        state.copyWith(
          status: HomeStatus.success,
          categories: categories,
          products: products,
        ),
      );
    } on AppException catch (e) {
      emit(state.copyWith(status: HomeStatus.failure, errorMessage: e.message));
    }
  }
}
