import 'package:injectable/injectable.dart';
import '../../data/models/request/login_request.dart';
import '../entity/auth.dart';
import '../repositories/auth_repository.dart';

@injectable
class LoginUseCase {
  final AuthRepository repository;
  LoginUseCase(this.repository);

  Future<AuthResponse> call(LoginRequest request) async {
    return await repository.login(request);
  }
}
