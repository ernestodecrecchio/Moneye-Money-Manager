import 'package:expense_tracker/Configuration/notification_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationNotifier extends Notifier<bool?> {
  @override
  bool? build() {
    return null;
  }

  void setFromLocalStorage(bool? localStorageValue) {
    state = localStorageValue;
  }

  Future<bool> updateNotificationsEnabledValue(bool newValue) async {
    state = newValue;

    if (newValue == false) {
      NotificationManager.clearAllNotifications();
    }

    final prefs = await SharedPreferences.getInstance();
    return await prefs.setBool('notifications_enabled', newValue);
  }
}

final notificationsEnabledProvider =
    NotifierProvider<NotificationNotifier, bool?>(() {
  return NotificationNotifier();
});

class NotificationTimeProvider extends Notifier<DateTime> {
  @override
  DateTime build() {
    return DateTime.now();
  }

  void setFromLocalStorage(String? localStorageValue) {
    if (localStorageValue != null) {
      state = DateTime.parse(localStorageValue);
    }
  }

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

final notificationTimeProvider =
    NotifierProvider<NotificationTimeProvider, DateTime>(() {
  return NotificationTimeProvider();
});
