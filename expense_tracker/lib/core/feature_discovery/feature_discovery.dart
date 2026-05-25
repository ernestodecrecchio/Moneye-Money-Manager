import 'package:expense_tracker/core/feature_discovery/feature_discovery_content.dart';
import 'package:expense_tracker/core/feature_discovery/feature_discovery_id.dart';
import 'package:expense_tracker/core/feature_discovery/feature_discovery_keys.dart';
import 'package:expense_tracker/core/feature_discovery/feature_discovery_provider.dart';
import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

/// Shows coach marks for the given [ids] in order, skipping items already seen
/// or whose target is not mounted yet.
class FeatureDiscovery {
  FeatureDiscovery._();

  static const Duration _scrollDuration = Duration(milliseconds: 350);
  static const Duration _scrollSettleDelay = Duration(milliseconds: 80);

  static GlobalKey? _keyFor(FeatureDiscoveryId id) =>
      FeatureDiscoveryKeys.get(id);

  static FeatureDiscoveryId? _idFromIdentify(dynamic identify) {
    if (identify is! String) return null;
    for (final id in FeatureDiscoveryId.values) {
      if (id.name == identify) return id;
    }
    return null;
  }

  static bool _isTargetReady(GlobalKey key) {
    final context = key.currentContext;
    if (context == null) return false;
    final renderObject = context.findRenderObject();
    return renderObject != null && renderObject.attached;
  }

  /// Scroll alignment when bringing a target into its nearest [Scrollable].
  static double _scrollAlignmentFor(FeatureDiscoveryId id) {
    return switch (id) {
      FeatureDiscoveryId.homeFab ||
      FeatureDiscoveryId.budgetListFab =>
        0.92,
      FeatureDiscoveryId.budgetTab => 1.0,
      FeatureDiscoveryId.balanceTrendBadge => 0.12,
      FeatureDiscoveryId.swipeToDelete ||
      FeatureDiscoveryId.homeBudgetSection =>
        0.55,
      FeatureDiscoveryId.recurringTransactionsSettings ||
      FeatureDiscoveryId.backupRestore =>
        0.35,
      FeatureDiscoveryId.budgetFormRollover => 0.75,
      _ => 0.5,
    };
  }

  /// Pixels reserved at screen edges so the focus ring and tooltip fit.
  static Rect _visibleViewport(BuildContext context, FeatureDiscoveryId id) {
    final media = MediaQuery.of(context);
    final padding = media.padding;
    final size = media.size;

    final bottomReserved = switch (id) {
      FeatureDiscoveryId.budgetTab => padding.bottom + 12,
      FeatureDiscoveryId.homeFab ||
      FeatureDiscoveryId.budgetListFab =>
        padding.bottom + 88,
      _ => padding.bottom + 72,
    };

    final topReserved = switch (id) {
      FeatureDiscoveryId.balanceTrendBadge => padding.top + 8,
      _ => padding.top + kToolbarHeight + 8,
    };

    return Rect.fromLTWH(
      12,
      topReserved,
      size.width - 24,
      size.height - topReserved - bottomReserved,
    );
  }

  /// True when a meaningful portion of the target lies inside the safe viewport.
  static bool _isTargetVisible(GlobalKey key, FeatureDiscoveryId id) {
    final context = key.currentContext;
    if (context == null) return false;

    final box = context.findRenderObject();
    if (box is! RenderBox || !box.hasSize || !box.attached) return false;

    final rect = box.localToGlobal(Offset.zero) & box.size;
    if (rect.width <= 0 || rect.height <= 0) return false;

    final viewport = _visibleViewport(context, id);
    final intersection = viewport.intersect(rect);
    if (intersection.isEmpty) return false;

    return intersection.height >= rect.height * 0.35 &&
        intersection.width >= rect.width * 0.35;
  }

  static Future<void> _ensureTargetVisible(
    GlobalKey key,
    FeatureDiscoveryId id,
  ) async {
    final context = key.currentContext;
    if (context == null || !context.mounted) return;

    try {
      await Scrollable.ensureVisible(
        context,
        duration: _scrollDuration,
        curve: Curves.easeInOut,
        alignment: _scrollAlignmentFor(id),
        alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
      );
    } catch (_) {
      // No scrollable ancestor (e.g. bottom bar) — target is already on screen.
    }

    await Future<void>.delayed(_scrollDuration + _scrollSettleDelay);
    if (context.mounted) {
      await WidgetsBinding.instance.endOfFrame;
    }
  }

  static List<FeatureDiscoveryId> unseenIds(
    WidgetRef ref,
    List<FeatureDiscoveryId> ids,
  ) {
    final notifier = ref.read(featureDiscoveryProvider.notifier);
    return ids.where((id) => !notifier.isSeen(id)).toList();
  }

  /// Runs after layout so targets attached in the same frame are found.
  static void scheduleShowSequence({
    required BuildContext context,
    required WidgetRef ref,
    required List<FeatureDiscoveryId> ids,
    Duration delay = const Duration(milliseconds: 400),
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future<void>.delayed(delay);
      if (!context.mounted) return;
      await showSequence(context: context, ref: ref, ids: ids);
    });
  }

  static Future<void> showSequence({
    required BuildContext context,
    required WidgetRef ref,
    required List<FeatureDiscoveryId> ids,
  }) async {
    final pending = unseenIds(ref, ids);
    if (pending.isEmpty) return;

    final targets = <TargetFocus>[];
    final shownIds = <FeatureDiscoveryId>[];

    for (final id in pending) {
      final key = _keyFor(id);
      if (key == null || !_isTargetReady(key)) continue;

      shownIds.add(id);
      targets.add(
        TargetFocus(
          identify: id.name,
          keyTarget: key,
          shape: ShapeLightFocus.RRect,
          radius: 12,
          paddingFocus: 8,
          contents: [
            TargetContent(
              align: _contentAlignFor(id),
              builder: (context, controller) => FeatureDiscoveryContent(
                title: id.title,
                description: id.description,
              ),
            ),
          ],
        ),
      );
    }

    if (targets.isEmpty || !context.mounted) return;

    final colors = context.appColors;
    final notifier = ref.read(featureDiscoveryProvider.notifier);

    TutorialCoachMark(
      targets: targets,
      colorShadow: Colors.black,
      opacityShadow: 0.82,
      textSkip: 'SKIP',
      textStyleSkip: TextStyle(
        color: colors.onPrimary,
        fontWeight: FontWeight.w600,
      ),
      alignSkip: Alignment.topRight,
      paddingFocus: 8,
      pulseEnable: true,
      beforeFocus: (target) async {
        final key = target.keyTarget;
        final id = _idFromIdentify(target.identify);
        if (key == null || id == null) return;

        await _ensureTargetVisible(key, id);

        // If still off-screen after scrolling, retry once with centered alignment.
        if (!_isTargetVisible(key, id)) {
          final retryContext = key.currentContext;
          if (retryContext != null && retryContext.mounted) {
            try {
              await Scrollable.ensureVisible(
                retryContext,
                duration: _scrollDuration,
                curve: Curves.easeInOut,
                alignment: 0.5,
                alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
              );
              await Future<void>.delayed(_scrollDuration + _scrollSettleDelay);
            } catch (_) {}
          }
        }
      },
      onSkip: () {
        notifier.markSeenAll(shownIds);
        return true;
      },
      onFinish: () {
        notifier.markSeenAll(shownIds);
      },
    ).show(context: context);
  }

  static ContentAlign _contentAlignFor(FeatureDiscoveryId id) {
    return switch (id) {
      FeatureDiscoveryId.homeFab ||
      FeatureDiscoveryId.budgetListFab =>
        ContentAlign.top,
      FeatureDiscoveryId.budgetTab ||
      FeatureDiscoveryId.swipeToDelete ||
      FeatureDiscoveryId.balanceTrendBadge =>
        ContentAlign.top,
      FeatureDiscoveryId.homeBudgetSection => ContentAlign.bottom,
      _ => ContentAlign.bottom,
    };
  }
}
