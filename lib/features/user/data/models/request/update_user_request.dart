class UpdateUserRequest {
  final String? username;
  final String? email;
  final String? phone;
  final String? fullName;
  final bool? enabled;
  final String? oldPassword;
  final String? newPassword;
  final String? confirmPassword;

  UpdateUserRequest({
    this.username,
    this.email,
    this.phone,
    this.fullName,
    this.enabled,
    this.oldPassword,
    this.newPassword,
    this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'username': username,
      'email': email,
      'phone': phone,
      'fullName': fullName,
      'enabled': enabled,
      'oldPassword': oldPassword,
      'newPassword': newPassword,
      'confirmPassword': confirmPassword,
    };
    data.removeWhere((key, value) => value == null);
    return data;
  }
}
