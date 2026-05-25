import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:flutter/material.dart';

/// Shared coach-mark tooltip body (English only until localization is added).
class FeatureDiscoveryContent extends StatelessWidget {
  final String title;
  final String description;

  const FeatureDiscoveryContent({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
            ),
          ),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              height: 1.35,
              color: colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
