import 'package:injectable/injectable.dart';

import '../../data/models/response/supplier_response.dart';
import '../repositories/supplier_repository.dart';

@injectable
class GetSuppliersUseCase {
  final SupplierRepository repository;

  GetSuppliersUseCase(this.repository);

  Future<List<SupplierResponse>> call() {
    return repository.getSuppliers();
  }
}
