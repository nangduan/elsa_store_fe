class RevenueTimeseriesPointResponse {
  final String? period;
  final int? ordersCount;
  final double? netRevenue;

  RevenueTimeseriesPointResponse({
    this.period,
    this.ordersCount,
    this.netRevenue,
  });

  factory RevenueTimeseriesPointResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return RevenueTimeseriesPointResponse(
      period: json['period'] as String?,
      ordersCount: json['ordersCount'] as int?,
      netRevenue: (json['netRevenue'] as num?)?.toDouble(),
    );
  }
}
