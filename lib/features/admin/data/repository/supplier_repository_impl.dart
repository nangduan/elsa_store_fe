import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/api/dio_client.dart';
import '../datasource/remote/supplier_api_service.dart';
import '../models/request/supplier_request.dart';
import '../models/response/supplier_response.dart';
import '../../domain/repositories/supplier_repository.dart';

@LazySingleton(as: SupplierRepository)
class SupplierRepositoryImpl implements SupplierRepository {
  final SupplierApiService apiService;
  final DioClient dioClient;

  SupplierRepositoryImpl(this.apiService, this.dioClient);

  @override
  Future<List<SupplierResponse>> getSuppliers() async {
    try {
      final apiResp = await apiService.getSuppliers();
      final data = apiResp.data;
      if (data is List) {
        return data
            .whereType<Map<String, dynamic>>()
            .map(SupplierResponse.fromJson)
            .toList();
      }
      return [];
    } on DioException catch (e) {
      throw dioClient.handleDioError(e);
    }
  }

  @override
  Future<SupplierResponse?> createSupplier(SupplierRequest request) async {
    try {
      final apiResp = await apiService.createSupplier(request);
      final data = apiResp.data;
      if (data is Map<String, dynamic>) {
        return SupplierResponse.fromJson(data);
      }
      return null;
    } on DioException catch (e) {
      throw dioClient.handleDioError(e);
    }
  }

  @override
  Future<SupplierResponse?> updateSupplier(
    int id,
    SupplierRequest request,
  ) async {
    try {
      final apiResp = await apiService.updateSupplier(id, request);
      final data = apiResp.data;
      if (data is Map<String, dynamic>) {
        return SupplierResponse.fromJson(data);
      }
      return null;
    } on DioException catch (e) {
      throw dioClient.handleDioError(e);
    }
  }

  @override
  Future<void> deleteSupplier(int id) async {
    try {
      await apiService.deleteSupplier(id);
    } on DioException catch (e) {
      throw dioClient.handleDioError(e);
    }
  }
}
