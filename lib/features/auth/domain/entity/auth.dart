import '../../data/models/response/user_response.dart';

class AuthResponse {
  bool? authenticated;
  String? accessToken;
  String? refreshToken;
  String? role;
  User? user;

  AuthResponse({
    this.authenticated,
    this.accessToken,
    this.refreshToken,
    this.role,
    this.user,
  });
}
