class AuthResponse {
  bool? authenticated;
  String? accessToken;
  String? refreshToken;
  String? role;
  String? accountId;

  AuthResponse({
    this.authenticated,
    this.accessToken,
    this.refreshToken,
    this.role,
    this.accountId,
  });
}
