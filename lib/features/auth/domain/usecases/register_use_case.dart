import 'package:injectable/injectable.dart';

import '../../data/models/request/register_request.dart';
import '../repositories/auth_repository.dart';

@injectable
class RegisterUseCase {
  final AuthRepository repository;
  RegisterUseCase(this.repository);

  Future<void> call(RegisterRequest request) async {
    return await repository.register(request);
  }
}
