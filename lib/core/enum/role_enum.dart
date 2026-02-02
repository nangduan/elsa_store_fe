enum Role {
  admin(value: 'ADMIN'),
  customer(value: 'CUSTOMER'),
  unknown(value: null);

  final String? value;

  const Role({required this.value});

  static Role fromString(String? value) {
    return Role.values.firstWhere(
      (e) => e.value == value,
      orElse: () => Role.unknown,
    );
  }
}

extension RoleExtensions on Role {
  bool get isAdmin => this == Role.admin;

  bool get isCustomer => this == Role.customer;
}
