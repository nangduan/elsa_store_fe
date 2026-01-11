import '../../data/models/request/supplier_request.dart';
import '../../data/models/response/supplier_response.dart';

abstract class SupplierRepository {
  Future<List<SupplierResponse>> getSuppliers();

  Future<SupplierResponse?> createSupplier(SupplierRequest request);

  Future<SupplierResponse?> updateSupplier(int id, SupplierRequest request);

  Future<void> deleteSupplier(int id);
}
