import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/services/notification_service.dart';
import '../../shared/providers/notification_provider.dart';
import '../../shared/widgets/app_toggle.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifProvider = context.watch<NotificationProvider>();
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          l.notificationTitle,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
              child: const Icon(Icons.person_outline, size: 20),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.marginMobile),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimensions.lg),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusXl),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppDimensions.sm + 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimaryContainer.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(
                          AppDimensions.radiusMd),
                    ),
                    child: Icon(
                      Icons.notifications_active,
                      size: 28,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l.managePreferences,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                        ),
                        Text(
                          l.managePreferencesSub,
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.lg),
            _settingsGroup(context, l.generalSettings, [
              _toggleItem(
                context,
                Icons.cell_tower,
                l.pushNotifications,
                l.pushNotificationsSub,
                notifProvider.pushEnabled,
                (v) => notifProvider.togglePush(v),
              ),
              _toggleItem(
                context,
                Icons.volume_up,
                l.sound,
                l.soundSub,
                notifProvider.soundEnabled,
                (v) => notifProvider.toggleSound(v),
              ),
            ]),
            const SizedBox(height: AppDimensions.md),
            _settingsGroup(context, l.eventsCalendar, [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _toggleItem(
                    context,
                    Icons.event_note,
                    l.eventReminder,
                    'Thông báo ${notifProvider.defaultReminderMinutes} phút trước khi bắt đầu',
                    notifProvider.reminderEnabled,
                    (v) => notifProvider.toggleReminder(v),
                  ),
                  if (notifProvider.reminderEnabled)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md).copyWith(bottom: AppDimensions.md),
                      child: Row(
                        children: [5, 15, 30].map((minutes) {
                          final isSelected = notifProvider.defaultReminderMinutes == minutes;
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: GestureDetector(
                                onTap: () => notifProvider.setDefaultReminderMinutes(minutes),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: isSelected ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).colorScheme.surfaceContainer,
                                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                                  ),
                                  child: Text(
                                    '$minutes phút',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                                      color: isSelected ? Theme.of(context).colorScheme.onPrimaryContainer : Theme.of(context).colorScheme.onSurface,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                ],
              ),
              _toggleItem(
                context,
                Icons.analytics,
                l.weeklyReport,
                l.weeklyReportSub,
                notifProvider.weeklyReportEnabled,
                (v) => notifProvider.toggleWeeklyReport(v),
              ),
            ]),
            const SizedBox(height: AppDimensions.md),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(AppDimensions.lg),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(
                          AppDimensions.radiusXl),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.schedule,
                            color: Theme.of(context).colorScheme.primary, size: 28),
                        const SizedBox(height: AppDimensions.sm),
                        Text(
                          l.quietHours,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          l.quietHoursSub,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: AppDimensions.md),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(AppDimensions.lg),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(
                          AppDimensions.radiusXl),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.emergency,
                            color: Theme.of(context).colorScheme.onSecondaryContainer,
                            size: 28),
                        const SizedBox(height: AppDimensions.sm),
                        Text(
                          l.emergencyPriority,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.onSecondaryContainer,
                          ),
                        ),
                        Text(
                          l.emergencyPrioritySub,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.onSecondaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.lg),
            // Test notification button

          ],
        ),
      ),
    );
  }

  Widget _settingsGroup(BuildContext context, String title, List<Widget> items) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.md,
              AppDimensions.sm + 4,
              AppDimensions.md,
              AppDimensions.sm,
            ),
            child: Text(
              title.toUpperCase(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.primary,
                letterSpacing: 1,
              ),
            ),
          ),
          ...items,
        ],
      ),
    );
  }

  Widget _toggleItem(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.md),
        margin: const EdgeInsets.only(bottom: AppDimensions.xs),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHigh,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 22),
            ),
            const SizedBox(width: AppDimensions.md),
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      subtitle,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
            ),
            AppToggle(value: value, onChanged: onChanged),
          ],
        ),
      ),
    );
  }
}
