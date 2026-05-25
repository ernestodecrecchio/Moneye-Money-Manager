import 'package:expense_tracker/core/feature_discovery/feature_discovery_id.dart';
import 'package:flutter/material.dart';

/// Runtime registry for coach-mark [GlobalKey]s.
///
/// Keys are owned by [FeatureDiscoveryTarget] widgets (one key per target id in
/// the tree). Do not attach static [GlobalKey]s to widgets inside animated
/// parents (e.g. [SalomonBottomBar]'s [TweenAnimationBuilder]).
class FeatureDiscoveryKeys {
  FeatureDiscoveryKeys._();

  static final Map<FeatureDiscoveryId, GlobalKey> _keys = {};

  static void register(FeatureDiscoveryId id, GlobalKey key) {
    assert(() {
      final existing = _keys[id];
      if (existing != null && existing != key) {
        debugPrint(
          'FeatureDiscoveryKeys: replacing key for $id (previous target unmounted?)',
        );
      }
      return true;
    }());
    _keys[id] = key;
  }

  static void unregister(FeatureDiscoveryId id, GlobalKey key) {
    if (_keys[id] == key) {
      _keys.remove(id);
    }
  }

  static GlobalKey? get(FeatureDiscoveryId id) => _keys[id];
}
