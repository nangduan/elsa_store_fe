import 'user_response.dart';

class LoginResponse {
  bool? authenticated;
  String? accessToken;
  String? refreshToken;
  String? role;
  User? user;

  LoginResponse({
    this.authenticated,
    this.accessToken,
    this.refreshToken,
    this.role,
    this.user,
  });

  LoginResponse.fromJson(Map<String, dynamic> json) {
    authenticated = json['authenticated'];
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
    role = json['role'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['authenticated'] = authenticated;
    data['accessToken'] = accessToken;
    data['refreshToken'] = refreshToken;
    data['role'] = role;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}
