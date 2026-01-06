import '../../data/models/request/login_request.dart';
import '../../data/models/request/register_request.dart';
import '../entity/auth.dart';

abstract class AuthRepository {
  Future<AuthResponse> login(LoginRequest request);

  Future<void> logout();

  Future<void> register(RegisterRequest request);
}
