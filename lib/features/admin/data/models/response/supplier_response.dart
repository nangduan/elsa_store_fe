class SupplierResponse {
  final int? id;
  final String? name;
  final String? phone;
  final String? address;
  final String? email;

  SupplierResponse({
    this.id,
    this.name,
    this.phone,
    this.address,
    this.email,
  });

  factory SupplierResponse.fromJson(Map<String, dynamic> json) {
    return SupplierResponse(
      id: json['id'] as int?,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      email: json['email'] as String?,
    );
  }
}
