class SupplierRequest {
  final String name;
  final String phone;
  final String address;
  final String email;

  SupplierRequest({
    required this.name,
    required this.phone,
    required this.address,
    required this.email,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'phone': phone,
        'address': address,
        'email': email,
      };
}
