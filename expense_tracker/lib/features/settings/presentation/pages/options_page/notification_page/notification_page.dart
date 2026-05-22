import 'package:app_settings/app_settings.dart';
import 'package:expense_tracker/core/configuration/notification_manager.dart';
import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/core/presentation/providers/notification_provider.dart';
import 'package:expense_tracker/core/presentation/common/custom_elevated_button.dart';
import 'package:expense_tracker/core/presentation/common/custom_text_field.dart';
import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/core/presentation/common/widgets/custom_snackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ReminderPage extends ConsumerStatefulWidget {
  static const routeName = '/reminderPage';

  const ReminderPage({super.key});

  @override
  ConsumerState<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends ConsumerState<ReminderPage> {
  final TextEditingController _timeController = TextEditingController();

  @override
  void dispose() {
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _handleTimeSelection() async {
    final currentTime = ref.read(notificationTimeProvider);
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(currentTime),
    );

    if (picked != null) {
      final now = DateTime.now();
      final selectedDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        picked.hour,
        picked.minute,
      );

      await ref
          .read(notificationTimeProvider.notifier)
          .updateNotificationsTimeValue(selectedDateTime);

      _timeController.text = DateFormat.Hm().format(selectedDateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    // Keep controller in sync with provider
    final currentTime = ref.watch(notificationTimeProvider);
    _timeController.text = DateFormat.Hm().format(currentTime);

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
                child: Column(
                  children: [
                    Text(
                      appLocalizations.reminderDescription,
                      style: textTheme.bodyLarge?.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            appLocalizations.dailyReminder,
                            style: textTheme.titleMedium?.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: colors.textPrimary,
                            ),
                          ),
                        ),
                        Switch.adaptive(
                          value:
                              ref.watch(notificationsEnabledProvider) ?? false,
                          activeTrackColor: colors.primary,
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
                      CustomTextField(
                        controller: _timeController,
                        readOnly: true,
                        icon: Icons.access_time_rounded,
                        onTap: _handleTimeSelection,
                      ),
                    ],
                    if (kDebugMode) ...[
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: CustomElevatedButton(
                          onPressed: () async {
                            await NotificationManager.showInstantNotification();
                            if (context.mounted) {
                              CustomSnackBar.show(
                                context,
                                message: appLocalizations.testNotificationSent,
                                type: SnackBarType.success,
                              );
                            }
                          },
                          text: appLocalizations.sendTestNotification,
                          isLoading: false,
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
