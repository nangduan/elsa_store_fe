import 'package:injectable/injectable.dart';

import '../../data/models/request/supplier_request.dart';
import '../../data/models/response/supplier_response.dart';
import '../repositories/supplier_repository.dart';

@injectable
class UpdateSupplierUseCase {
  final SupplierRepository repository;

  UpdateSupplierUseCase(this.repository);

  Future<SupplierResponse?> call(int id, SupplierRequest request) {
    return repository.updateSupplier(id, request);
  }
}
