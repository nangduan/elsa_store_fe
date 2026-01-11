import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/app_exception.dart';
import '../../data/models/request/category_request.dart';
import '../../data/models/response/category_response.dart';
import '../../domain/usecases/create_category_use_case.dart';
import '../../domain/usecases/delete_category_use_case.dart';
import '../../domain/usecases/get_categories_use_case.dart';
import '../../domain/usecases/update_category_use_case.dart';

part 'category_state.dart';
part 'category_cubit.freezed.dart';

@injectable
class CategoryCubit extends Cubit<CategoryState> {
  final GetCategoriesUseCase _getCategories;
  final CreateCategoryUseCase _createCategory;
  final UpdateCategoryUseCase _updateCategory;
  final DeleteCategoryUseCase _deleteCategory;

  CategoryCubit(
    this._getCategories,
    this._createCategory,
    this._updateCategory,
    this._deleteCategory,
  ) : super(CategoryState());

  Future<void> load() async {
    emit(state.copyWith(status: CategoryStatus.loading));
    try {
      final items = await _getCategories();
      emit(state.copyWith(status: CategoryStatus.success, categories: items));
    } on AppException catch (e) {
      emit(state.copyWith(status: CategoryStatus.failure, errorMessage: e.message));
    }
  }

  Future<void> create(CategoryRequest request) async {
    emit(state.copyWith(status: CategoryStatus.loading));
    try {
      await _createCategory(request);
      await load();
    } on AppException catch (e) {
      emit(state.copyWith(status: CategoryStatus.failure, errorMessage: e.message));
    }
  }

  Future<void> update(int id, CategoryRequest request) async {
    emit(state.copyWith(status: CategoryStatus.loading));
    try {
      await _updateCategory(id, request);
      await load();
    } on AppException catch (e) {
      emit(state.copyWith(status: CategoryStatus.failure, errorMessage: e.message));
    }
  }

  Future<void> remove(int id) async {
    emit(state.copyWith(status: CategoryStatus.loading));
    try {
      await _deleteCategory(id);
      await load();
    } on AppException catch (e) {
      emit(state.copyWith(status: CategoryStatus.failure, errorMessage: e.message));
    }
  }
}
