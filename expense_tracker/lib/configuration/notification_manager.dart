import 'dart:async';
import 'dart:io';
import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:expense_tracker/models/recieved_notification.dart';
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
      initializationSettings,
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

      return await androidImplementation?.requestNotificationsPermission();
    }

    return false;
  }

  static Future clearAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  static Future<void> scheduleDailyNotification({
    required TimeOfDay atTime,
  }) async {
    AppLocalizations localizations = await AppLocalizations.delegate.load(
      Locale(Intl.shortLocale(Intl.getCurrentLocale().toString())),
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        localizations.notificationTitle,
        localizations.notificationSubtitle,
        _nextInstanceOfTwelveAM(time: atTime),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily notification channel id',
            'daily notification channel name',
            channelDescription: 'daily notification description',
            importance: Importance.max,
            priority: Priority.high,
            icon:
                '@drawable/ic_stat_logo_transparent', // Icon for the notification in android status bar
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  static TZDateTime _nextInstanceOfTwelveAM({required TimeOfDay time}) {
    final TZDateTime now = TZDateTime.now(local);
    TZDateTime scheduledDate =
        TZDateTime(local, now.year, now.month, now.day, time.hour, time.minute);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
