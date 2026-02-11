import 'dart:async';
import 'dart:io';
import 'package:expense_tracker/domain/models/recieved_notification.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart';

class NotificationManager {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Streams are created so that app can respond to notification-related events
  /// since the plugin is initialised in the `main` function
  static final StreamController<ReceivedNotification>
      didReceiveLocalNotificationStream =
      StreamController<ReceivedNotification>.broadcast();

  static final StreamController<String?> selectNotificationStream =
      StreamController<String?>.broadcast();

  static String? selectedNotificationPayload;

  /// A notification action which triggers a App navigation event
  static String navigationActionId = 'id_3';

  /// Defines a iOS/MacOS notification category for text input actions.
  static String darwinNotificationCategoryText = 'textCategory';

  /// Defines a iOS/MacOS notification category for plain actions.
  static String darwinNotificationCategoryPlain = 'plainCategory';

  /// Channel ID for daily reminders
  static const String dailyReminderChannelId = 'daily_reminder_channel';

  @pragma('vm:entry-point')
  static void notificationTapBackground(
      NotificationResponse notificationResponse) {
    // ignore: avoid_print
    print('notification(${notificationResponse.id}) action tapped: '
        '${notificationResponse.actionId} with'
        ' payload: ${notificationResponse.payload}');

    if (notificationResponse.input?.isNotEmpty ?? false) {
      // ignore: avoid_print
      print(
          'notification action tapped with input: ${notificationResponse.input}');
    }
  }

  static Future initNotificationManager() async {
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        !kIsWeb && Platform.isLinux
            ? null
            : await flutterLocalNotificationsPlugin
                .getNotificationAppLaunchDetails();

    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      NotificationManager.selectedNotificationPayload =
          notificationAppLaunchDetails!.notificationResponse?.payload;
    }

    // Android Notification Settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    // Darwin Notification Settings (iOS & MacOS)
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Linux Nofification Settings
    final LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(
      defaultActionName: 'Open notification',
      defaultIcon: AssetsLinuxIcon('icons/app_icon.png'),
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
      linux: initializationSettingsLinux,
    );

    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        switch (notificationResponse.notificationResponseType) {
          case NotificationResponseType.selectedNotification:
            selectNotificationStream.add(notificationResponse.payload);
            break;
          case NotificationResponseType.selectedNotificationAction:
            if (notificationResponse.actionId == navigationActionId) {
              selectNotificationStream.add(notificationResponse.payload);
            }
            break;
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  static Future<bool?> requestNotificationPermissions() async {
    if (Platform.isMacOS) {
      return await NotificationManager.flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isIOS) {
      return await NotificationManager.flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          NotificationManager.flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>();

      // Ensure notifications are permitted on Android 13+
      await androidImplementation?.requestNotificationsPermission();

      // Check for exact alarm permission
      var hasExactAlarmPermission =
          await androidImplementation?.canScheduleExactNotifications() ?? false;

      if (!hasExactAlarmPermission) {
        // This will redirect the user to the system settings page for "Alarms & Reminders"
        await androidImplementation?.requestExactAlarmsPermission();
      }

      // Return the overall status of notifications (true if granted, false/null otherwise)
      return await androidImplementation?.areNotificationsEnabled();
    }

    return false;
  }

  static Future clearAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  static Future<void> scheduleDailyNotification({
    required TimeOfDay atTime,
  }) async {
    try {
      AppLocalizations localizations = await AppLocalizations.delegate.load(
        Locale(Intl.shortLocale(Intl.getCurrentLocale().toString())),
      );

      AndroidScheduleMode scheduleMode =
          AndroidScheduleMode.exactAllowWhileIdle;

      if (Platform.isAndroid) {
        final androidImplementation = flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();

        final bool? canScheduleExact =
            await androidImplementation?.canScheduleExactNotifications();

        if (canScheduleExact != true) {
          print("### permission missing");
          // If the permission is missing, fallback to inexact to avoid crashing
          scheduleMode = AndroidScheduleMode.inexactAllowWhileIdle;
        } else {
          print("### permission granted");
        }
      }

      print("### ${localizations.notificationTitle}");
      print("### ${_nextInstanceOfTimeOfDay(time: atTime)}");

      await flutterLocalNotificationsPlugin.zonedSchedule(
          id: 0,
          title: localizations.notificationTitle,
          body: localizations.notificationSubtitle,
          scheduledDate: _nextInstanceOfTimeOfDay(time: atTime),
          notificationDetails: NotificationDetails(
            android: AndroidNotificationDetails(
              dailyReminderChannelId,
              localizations.dailyReminderChannelName,
              channelDescription: localizations.dailyReminderChannelDescription,
              importance: Importance.max,
              priority: Priority.high,
              icon: '@drawable/ic_stat_logo_transparent',
            ),
          ),
          androidScheduleMode: scheduleMode,
          matchDateTimeComponents: DateTimeComponents.time);
    } catch (e) {
      if (kDebugMode) {
        print('Error scheduling notification: $e');
      }
    }
  }

  /// Updates all scheduled notifications with current localization settings.
  /// This should be called when the app's locale changes.
  static Future<void> updateScheduledNotifications({
    required TimeOfDay atTime,
  }) async {
    await clearAllNotifications();
    await scheduleDailyNotification(atTime: atTime);
  }

  /// Returns the next future occurrence of the given [TimeOfDay],
  /// calculated in the local timezone.
  ///
  /// The resulting date will be:
  /// - **today** at the specified time, if that time has not passed yet
  /// - **tomorrow** at the same time, if it has already passed today
  ///
  /// Useful for scheduling daily recurring events
  /// (e.g. local notifications, background tasks, reminders).
  ///
  /// Example:
  /// - Current time: 3:30 PM
  /// - [time]: 12:00 PM
  /// → Result: tomorrow at 12:00 PM
  ///
  /// - Current time: 9:00 AM
  /// - [time]: 12:00 PM
  /// → Result: today at 12:00 PM
  static TZDateTime _nextInstanceOfTimeOfDay({required TimeOfDay time}) {
    final TZDateTime now = TZDateTime.now(local);
    TZDateTime scheduledDate =
        TZDateTime(local, now.year, now.month, now.day, time.hour, time.minute);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
