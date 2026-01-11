class PromotionResponse {
  final int? id;
  final String? name;
  final String? description;
  final int? type;
  final double? value;
  final String? startDate;
  final String? endDate;
  final int? status;
  final String? couponCode;
  final double? minOrderValue;

  PromotionResponse({
    this.id,
    this.name,
    this.description,
    this.type,
    this.value,
    this.startDate,
    this.endDate,
    this.status,
    this.couponCode,
    this.minOrderValue,
  });

  factory PromotionResponse.fromJson(Map<String, dynamic> json) {
    return PromotionResponse(
      id: json['id'] as int?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      type: json['type'] as int?,
      value: (json['value'] as num?)?.toDouble(),
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      status: json['status'] as int?,
      couponCode: json['couponCode'] as String?,
      minOrderValue: (json['minOrderValue'] as num?)?.toDouble(),
    );
  }
}
