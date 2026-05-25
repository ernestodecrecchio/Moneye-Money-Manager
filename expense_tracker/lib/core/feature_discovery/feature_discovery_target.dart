import 'package:expense_tracker/core/feature_discovery/feature_discovery_id.dart';
import 'package:expense_tracker/core/feature_discovery/feature_discovery_keys.dart';
import 'package:flutter/material.dart';

/// Wraps a single coach-mark target. Creates a unique [GlobalKey] per instance
/// and registers it for [FeatureDiscovery].
class FeatureDiscoveryTarget extends StatefulWidget {
  final FeatureDiscoveryId id;
  final Widget child;

  const FeatureDiscoveryTarget({
    super.key,
    required this.id,
    required this.child,
  });

  @override
  State<FeatureDiscoveryTarget> createState() => _FeatureDiscoveryTargetState();
}

class _FeatureDiscoveryTargetState extends State<FeatureDiscoveryTarget> {
  final GlobalKey _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    FeatureDiscoveryKeys.register(widget.id, _key);
  }

  @override
  void dispose() {
    FeatureDiscoveryKeys.unregister(widget.id, _key);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: _key,
      child: widget.child,
    );
  }
}
