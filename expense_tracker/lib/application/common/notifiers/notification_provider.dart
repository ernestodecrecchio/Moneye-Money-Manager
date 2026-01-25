import 'package:expense_tracker/Configuration/notification_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Notifier managing the global enabled/disabled state of notifications.
class NotificationNotifier extends Notifier<bool?> {
  @override
  bool? build() {
    return null;
  }

  /// Sets the initial notification status from local storage.
  void setFromLocalStorage(bool? localStorageValue) {
    state = localStorageValue;
  }

  /// Updates and persists the notification enabled status.
  Future<bool> updateNotificationsEnabledValue(bool newValue) async {
    state = newValue;

    if (newValue == false) {
      NotificationManager.clearAllNotifications();
    }

    final prefs = await SharedPreferences.getInstance();
    return await prefs.setBool('notifications_enabled', newValue);
  }
}

/// Provider for the [NotificationNotifier].
final notificationsEnabledProvider =
    NotifierProvider<NotificationNotifier, bool?>(() {
  return NotificationNotifier();
});

/// Notifier managing the time at which daily notifications should be sent.
class NotificationTimeProvider extends Notifier<DateTime> {
  @override
  DateTime build() {
    return DateTime.now();
  }

  /// Sets the notification time from a persisted ISO string.
  void setFromLocalStorage(String? localStorageValue) {
    if (localStorageValue != null) {
      state = DateTime.parse(localStorageValue);
    }
  }

  /// Updates the notification time, schedules new notifications, and persists the setting.
  Future<bool> updateNotificationsTimeValue(DateTime newTimeValue) async {
    await NotificationManager.clearAllNotifications();

    await NotificationManager.scheduleDailyNotification(
        atTime: TimeOfDay.fromDateTime(newTimeValue));

    state = newTimeValue;

    final prefs = await SharedPreferences.getInstance();

    final currentDate = DateTime.now();
    final timeToDate = DateTime(currentDate.year, currentDate.month,
        currentDate.day, newTimeValue.hour, newTimeValue.minute);

    return await prefs.setString(
        'notification_time', timeToDate.toIso8601String());
  }
}

/// Provider for the [NotificationTimeProvider].
final notificationTimeProvider =
    NotifierProvider<NotificationTimeProvider, DateTime>(() {
  return NotificationTimeProvider();
});
