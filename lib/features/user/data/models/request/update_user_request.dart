class UpdateUserRequest {
  final String? username;
  final String? email;
  final String? phone;
  final String? fullName;
  final bool? enabled;
  final String? password;
  final String? oldPassword;

  UpdateUserRequest({
    this.username,
    this.email,
    this.phone,
    this.fullName,
    this.enabled,
    this.password,
    this.oldPassword,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'username': username,
      'email': email,
      'phone': phone,
      'fullName': fullName,
      'enabled': enabled,
      'password': password,
      'oldPassword': oldPassword,
    };
    data.removeWhere((key, value) => value == null);
    return data;
  }
}
