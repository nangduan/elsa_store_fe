import 'revenue_timeseries_point_response.dart';

class RevenueTimeseriesResponse {
  final String? from;
  final String? to;
  final String? groupBy;
  final List<RevenueTimeseriesPointResponse> points;

  RevenueTimeseriesResponse({
    this.from,
    this.to,
    this.groupBy,
    this.points = const [],
  });

  factory RevenueTimeseriesResponse.fromJson(Map<String, dynamic> json) {
    final rawPoints = json['points'];
    return RevenueTimeseriesResponse(
      from: json['from'] as String?,
      to: json['to'] as String?,
      groupBy: json['groupBy'] as String?,
      points: rawPoints is List
          ? rawPoints
              .whereType<Map<String, dynamic>>()
              .map(RevenueTimeseriesPointResponse.fromJson)
              .toList()
          : const [],
    );
  }
}
