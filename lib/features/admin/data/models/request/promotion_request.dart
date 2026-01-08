class PromotionRequest {
  final String name;
  final String description;
  final int type;
  final double value;
  final String startDate;
  final String endDate;
  final int status;
  final String couponCode;
  final double minOrderValue;

  PromotionRequest({
    required this.name,
    required this.description,
    required this.type,
    required this.value,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.couponCode,
    required this.minOrderValue,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'type': type,
        'value': value,
        'startDate': startDate,
        'endDate': endDate,
        'status': status,
        'couponCode': couponCode,
        'minOrderValue': minOrderValue,
      };
}
