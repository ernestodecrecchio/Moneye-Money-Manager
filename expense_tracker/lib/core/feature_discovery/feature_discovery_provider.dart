import 'package:expense_tracker/core/feature_discovery/feature_discovery_id.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeatureDiscoveryNotifier extends Notifier<Set<FeatureDiscoveryId>> {
  @override
  Set<FeatureDiscoveryId> build() => {};

  void setFromLocalStorage(Set<FeatureDiscoveryId> seen) {
    state = seen;
  }

  bool isSeen(FeatureDiscoveryId id) => state.contains(id);

  Future<void> markSeen(FeatureDiscoveryId id) async {
    if (state.contains(id)) return;

    state = {...state, id};
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(id.storageKey, true);
  }

  Future<void> markSeenAll(Iterable<FeatureDiscoveryId> ids) async {
    for (final id in ids) {
      await markSeen(id);
    }
  }

  /// Clears all discovery flags (debug / QA).
  Future<void> resetAll() async {
    final prefs = await SharedPreferences.getInstance();
    for (final id in FeatureDiscoveryId.values) {
      await prefs.remove(id.storageKey);
    }
    state = {};
  }

  static Future<Set<FeatureDiscoveryId>> loadSeenFromPrefs(
    SharedPreferences prefs,
  ) async {
    final seen = <FeatureDiscoveryId>{};
    for (final id in FeatureDiscoveryId.values) {
      if (prefs.getBool(id.storageKey) == true) {
        seen.add(id);
      }
    }
    return seen;
  }
}

final featureDiscoveryProvider =
    NotifierProvider<FeatureDiscoveryNotifier, Set<FeatureDiscoveryId>>(() {
  return FeatureDiscoveryNotifier();
});
