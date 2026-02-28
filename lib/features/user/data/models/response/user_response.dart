class UserResponse {
  final int? id;
  final String? username;
  final String? email;
  final String? phone;
  final String? fullName;
  final bool? enabled;

  UserResponse({
    this.id,
    this.username,
    this.email,
    this.phone,
    this.fullName,
    this.enabled,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json['id'] as int?,
      username: json['username'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      fullName: json['fullName'] as String?,
      enabled: json['enabled'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'phone': phone,
      'fullName': fullName,
      'enabled': enabled,
    };
  }
}
