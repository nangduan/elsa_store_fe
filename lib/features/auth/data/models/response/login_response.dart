class LoginResponse {
  bool? authenticated;
  String? accessToken;
  String? refreshToken;
  String? role;
  String? accountId;

  LoginResponse({
    this.authenticated,
    this.accessToken,
    this.refreshToken,
    this.role,
    this.accountId,
  });

  LoginResponse.fromJson(Map<String, dynamic> json) {
    authenticated = json['authenticated'];
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
    role = json['role'];
    accountId = json['accountId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['authenticated'] = authenticated;
    data['accessToken'] = accessToken;
    data['refreshToken'] = refreshToken;
    data['role'] = role;
    data['accountId'] = accountId;
    return data;
  }
}
