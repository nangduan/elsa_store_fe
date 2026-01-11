import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/app_exception.dart';
import '../../data/models/request/supplier_request.dart';
import '../../data/models/response/supplier_response.dart';
import '../../domain/usecases/create_supplier_use_case.dart';
import '../../domain/usecases/delete_supplier_use_case.dart';
import '../../domain/usecases/get_suppliers_use_case.dart';
import '../../domain/usecases/update_supplier_use_case.dart';

part 'supplier_state.dart';
part 'supplier_cubit.freezed.dart';

@injectable
class SupplierCubit extends Cubit<SupplierState> {
  final GetSuppliersUseCase _getSuppliers;
  final CreateSupplierUseCase _createSupplier;
  final UpdateSupplierUseCase _updateSupplier;
  final DeleteSupplierUseCase _deleteSupplier;

  SupplierCubit(
    this._getSuppliers,
    this._createSupplier,
    this._updateSupplier,
    this._deleteSupplier,
  ) : super(SupplierState());

  Future<void> load() async {
    emit(state.copyWith(status: SupplierStatus.loading));
    try {
      final items = await _getSuppliers();
      emit(state.copyWith(status: SupplierStatus.success, suppliers: items));
    } on AppException catch (e) {
      emit(state.copyWith(status: SupplierStatus.failure, errorMessage: e.message));
    }
  }

  Future<void> create(SupplierRequest request) async {
    emit(state.copyWith(status: SupplierStatus.loading));
    try {
      await _createSupplier(request);
      await load();
    } on AppException catch (e) {
      emit(state.copyWith(status: SupplierStatus.failure, errorMessage: e.message));
    }
  }

  Future<void> update(int id, SupplierRequest request) async {
    emit(state.copyWith(status: SupplierStatus.loading));
    try {
      await _updateSupplier(id, request);
      await load();
    } on AppException catch (e) {
      emit(state.copyWith(status: SupplierStatus.failure, errorMessage: e.message));
    }
  }

  Future<void> remove(int id) async {
    emit(state.copyWith(status: SupplierStatus.loading));
    try {
      await _deleteSupplier(id);
      await load();
    } on AppException catch (e) {
      emit(state.copyWith(status: SupplierStatus.failure, errorMessage: e.message));
    }
  }
}
