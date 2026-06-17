import 'package:expense_tracker/features/statistics/domain/models/insight_severity.dart';
import 'package:flutter/material.dart';

class StatisticsInsight {
  const StatisticsInsight({
    required this.title,
    required this.description,
    this.icon,
    this.severity,
  });

  final String title;
  final String description;
  final IconData? icon;
  final InsightSeverity? severity;
}
