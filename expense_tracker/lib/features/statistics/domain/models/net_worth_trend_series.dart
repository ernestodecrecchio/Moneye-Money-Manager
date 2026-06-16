class NetWorthTrendPoint {
  const NetWorthTrendPoint({
    required this.date,
    required this.netWorth,
  });

  final DateTime date;
  final double netWorth;
}

class NetWorthTrendSeries {
  const NetWorthTrendSeries({required this.points});

  final List<NetWorthTrendPoint> points;

  bool get hasInsufficientData => points.length < 2;

  double get minNetWorth {
    if (points.isEmpty) {
      return 0;
    }
    return points.map((point) => point.netWorth).reduce(
          (left, right) => left < right ? left : right,
        );
  }

  double get maxNetWorth {
    if (points.isEmpty) {
      return 0;
    }
    return points.map((point) => point.netWorth).reduce(
          (left, right) => left > right ? left : right,
        );
  }
}
