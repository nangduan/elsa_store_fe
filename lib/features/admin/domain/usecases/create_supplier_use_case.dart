import 'package:injectable/injectable.dart';

import '../../data/models/request/supplier_request.dart';
import '../../data/models/response/supplier_response.dart';
import '../repositories/supplier_repository.dart';

@injectable
class CreateSupplierUseCase {
  final SupplierRepository repository;

  CreateSupplierUseCase(this.repository);

  Future<SupplierResponse?> call(SupplierRequest request) {
    return repository.createSupplier(request);
  }
}
