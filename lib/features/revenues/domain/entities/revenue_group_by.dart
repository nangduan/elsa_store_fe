enum RevenueGroupBy { day, month, year }

extension RevenueGroupByX on RevenueGroupBy {
  String get apiValue {
    switch (this) {
      case RevenueGroupBy.day:
        return 'DAY';
      case RevenueGroupBy.month:
        return 'MONTH';
      case RevenueGroupBy.year:
        return 'YEAR';
    }
  }
}
