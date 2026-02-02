class RevenueSummaryResponse {
  final String? from;
  final String? to;
  final int? ordersCount;
  final double? grossRevenue;
  final double? discountTotal;
  final double? netRevenue;
  final double? averageOrderValue;

  RevenueSummaryResponse({
    this.from,
    this.to,
    this.ordersCount,
    this.grossRevenue,
    this.discountTotal,
    this.netRevenue,
    this.averageOrderValue,
  });

  factory RevenueSummaryResponse.fromJson(Map<String, dynamic> json) {
    return RevenueSummaryResponse(
      from: json['from'] as String?,
      to: json['to'] as String?,
      ordersCount: json['ordersCount'] as int?,
      grossRevenue: (json['grossRevenue'] as num?)?.toDouble(),
      discountTotal: (json['discountTotal'] as num?)?.toDouble(),
      netRevenue: (json['netRevenue'] as num?)?.toDouble(),
      averageOrderValue: (json['averageOrderValue'] as num?)?.toDouble(),
    );
  }
}
