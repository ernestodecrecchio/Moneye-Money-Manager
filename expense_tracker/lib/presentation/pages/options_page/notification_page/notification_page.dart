import 'package:app_settings/app_settings.dart';
import 'package:expense_tracker/Configuration/notification_manager.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:expense_tracker/notifiers/notification_provider.dart';
import 'package:expense_tracker/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReminderPage extends ConsumerWidget {
  static const routeName = '/reminderPage';

  const ReminderPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Promemoria'),
        backgroundColor: CustomColors.blue,
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
                      AppLocalizations.of(context)!.reminderDescription,
                      style: const TextStyle(
                          color: CustomColors.clearGreyText, fontSize: 16),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            AppLocalizations.of(context)!.dailyReminder,
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
                              final isPermissionGranted =
                                  await NotificationManager
                                          .requestNotificationPermissions() ??
                                      false;

                              if (!isPermissionGranted) {
                                AppSettings.openAppSettings(
                                    type: AppSettingsType.notification,
                                    asAnotherTask: true);
                              } else {
                                await ref
                                    .read(notificationsEnabledProvider.notifier)
                                    .updateNotificationsEnabledValue(true);

                                await ref
                                    .read(notificationTimeProvider.notifier)
                                    .updateNotificationsTimeValue(
                                        ref.read(notificationTimeProvider));
                              }
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
