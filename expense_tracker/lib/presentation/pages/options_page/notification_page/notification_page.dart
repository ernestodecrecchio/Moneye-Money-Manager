import 'package:app_settings/app_settings.dart';
import 'package:expense_tracker/configuration/notification_manager.dart';
import 'package:expense_tracker/application/common/notifiers/app_localizations_provider.dart';
import 'package:expense_tracker/application/common/notifiers/notification_provider.dart';
import 'package:expense_tracker/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReminderPage extends ConsumerWidget {
  static const routeName = '/reminderPage';

  const ReminderPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.reminder),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 17),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0, top: 30),
                  child: Column(children: [
                    Text(
                      appLocalizations.reminderDescription,
                      style: const TextStyle(
                          color: CustomColors.clearGreyText, fontSize: 16),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            appLocalizations.dailyReminder,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: CustomColors.lightBlack,
                            ),
                          ),
                        ),
                        Switch.adaptive(
                          activeThumbColor: CustomColors.blue,
                          value:
                              ref.watch(notificationsEnabledProvider) ?? false,
                          onChanged: (newValue) async {
                            if (newValue) {
                              final isNotificationPermissionGranted =
                                  await NotificationManager
                                          .requestNotificationPermissions() ??
                                      false;

                              if (!isNotificationPermissionGranted) {
                                AppSettings.openAppSettings(
                                    type: AppSettingsType.notification,
                                    asAnotherTask: true);
                                return;
                              }

                              final isExactAlarmPermissionGranted =
                                  await NotificationManager
                                      .isExactAlarmPermissionGranted();

                              if (!isExactAlarmPermissionGranted) {
                                // The previous requestNotificationPermissions calls requestExactAlarmsPermission internally on Android.
                                // If we are here, it means the user might have returned after being redirected.
                                // We check again. If still false, we don't enable.
                                await ref
                                    .read(notificationsEnabledProvider.notifier)
                                    .updateNotificationsEnabledValue(false);
                                return;
                              }

                              await ref
                                  .read(notificationsEnabledProvider.notifier)
                                  .updateNotificationsEnabledValue(true);

                              await ref
                                  .read(notificationTimeProvider.notifier)
                                  .updateNotificationsTimeValue(
                                      ref.read(notificationTimeProvider));
                            } else {
                              ref
                                  .read(notificationsEnabledProvider.notifier)
                                  .updateNotificationsEnabledValue(false);
                            }
                          },
                        ),
                      ],
                    ),
                    if (ref.watch(notificationsEnabledProvider) ?? false) ...[
                      const SizedBox(
                        height: 14,
                      ),
                      SizedBox(
                        height: 200,
                        child: CupertinoDatePicker(
                          use24hFormat: true,
                          mode: CupertinoDatePickerMode.time,
                          initialDateTime: ref.read(notificationTimeProvider),
                          onDateTimeChanged: (timePicked) async {
                            await ref
                                .read(notificationTimeProvider.notifier)
                                .updateNotificationsTimeValue(timePicked);
                          },
                        ),
                      ),
                    ]
                  ])),
            ),
          ],
        ),
      ),
    );
  }
}
