import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_dimensions.dart';
import '../../shared/providers/event_provider.dart';
import '../../domain/entities/event.dart';

class NotificationHistoryScreen extends StatelessWidget {
  const NotificationHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: cs.surface,
        appBar: AppBar(
          backgroundColor: cs.surface,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'Thông báo',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: cs.onSurface,
            ),
          ),
          centerTitle: true,
          bottom: TabBar(
            labelColor: cs.primary,
            unselectedLabelColor: cs.onSurfaceVariant,
            indicatorColor: cs.primary,
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            unselectedLabelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            tabs: const [
              Tab(text: 'Nhắc nhở'),
              Tab(text: 'Bỏ lỡ'),
            ],
          ),
        ),
        body: Consumer<EventProvider>(
          builder: (context, eventProvider, _) {
            final now = DateTime.now();

            // --- Reminders: ongoing + upcoming events (endTime still in the future) ---
            final reminders = eventProvider.events.where((e) {
              return !e.isCompleted && e.endTime.isAfter(now);
            }).toList()
              ..sort((a, b) => a.startTime.compareTo(b.startTime));

            // --- Missed: past events that are NOT completed ---
            final missed = eventProvider.events.where((e) {
              return !e.isCompleted && e.endTime.isBefore(now);
            }).toList()
              ..sort((a, b) => b.endTime.compareTo(a.endTime));

            return TabBarView(
              children: [
                _buildList(context, reminders, _NotifType.reminder),
                _buildList(context, missed, _NotifType.missed),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, List<Event> events, _NotifType type) {
    final cs = Theme.of(context).colorScheme;

    if (events.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              type == _NotifType.reminder
                  ? Icons.notifications_none
                  : Icons.event_busy_outlined,
              size: 64,
              color: cs.outlineVariant,
            ),
            const SizedBox(height: AppDimensions.md),
            Text(
              type == _NotifType.reminder
                  ? 'Không có nhắc nhở nào'
                  : 'Không có sự kiện bỏ lỡ',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: cs.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppDimensions.xs),
            Text(
              type == _NotifType.reminder
                  ? 'Các sự kiện sắp tới có hẹn giờ nhắc nhở\nsẽ xuất hiện ở đây.'
                  : 'Các sự kiện đã qua mà bạn chưa hoàn thành\nsẽ xuất hiện ở đây.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: cs.outline,
              ),
            ),
          ],
        ),
      );
    }

    // Group events by date
    final Map<String, List<Event>> grouped = {};
    for (final e in events) {
      final key = _dateGroupKey(
        type == _NotifType.reminder ? e.startTime : e.endTime,
      );
      grouped.putIfAbsent(key, () => []).add(e);
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.marginMobile,
        vertical: AppDimensions.md,
      ),
      itemCount: grouped.length,
      itemBuilder: (context, sectionIndex) {
        final dateKey = grouped.keys.elementAt(sectionIndex);
        final items = grouped[dateKey]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (sectionIndex > 0) const SizedBox(height: AppDimensions.md),
            Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.sm),
              child: Text(
                dateKey,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: cs.onSurfaceVariant,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            ...items.map((event) => _NotifCard(event: event, type: type)),
          ],
        );
      },
    );
  }

  String _dateGroupKey(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(dt.year, dt.month, dt.day);
    final diff = target.difference(today).inDays;

    if (diff == 0) return 'Hôm nay';
    if (diff == 1) return 'Ngày mai';
    if (diff == -1) return 'Hôm qua';
    return DateFormat('EEEE, dd/MM', 'vi').format(dt);
  }
}

enum _NotifType { reminder, missed }

class _NotifCard extends StatelessWidget {
  final Event event;
  final _NotifType type;
  const _NotifCard({required this.event, required this.type});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final eventColor = Color(event.colorHex);
    final isReminder = type == _NotifType.reminder;

    final accentColor = isReminder ? cs.primary : cs.error;
    final icon = isReminder
        ? Icons.notifications_active
        : Icons.warning_amber_rounded;

    final timeStr = DateFormat('HH:mm').format(event.startTime);
    final endTimeStr = DateFormat('HH:mm').format(event.endTime);

    final now = DateTime.now();
    final isOngoing = isReminder && event.startTime.isBefore(now);

    String subtitle;
    if (isReminder) {
      if (isOngoing) {
        subtitle = 'Đang diễn ra • $timeStr - $endTimeStr';
      } else if (event.reminderMinutes.isNotEmpty) {
        subtitle = 'Nhắc nhở trước ${event.reminderMinutes.first} phút • $timeStr';
      } else {
        subtitle = 'Sắp diễn ra lúc $timeStr';
      }
    } else {
      subtitle = 'Đã kết thúc lúc $endTimeStr • ${_timeAgo(event.endTime)}';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.sm),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(
          color: cs.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          onTap: () {
            Navigator.of(context).pushNamed('/add_event', arguments: event);
          },
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.md),
            child: Row(
              children: [
                // Leading icon
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  ),
                  child: Icon(icon, color: accentColor, size: 22),
                ),
                const SizedBox(width: AppDimensions.md),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: eventColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              event.title,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: cs.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                // Trailing time badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isReminder
                        ? cs.primaryContainer
                        : cs.errorContainer,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                  ),
                  child: Text(
                    timeStr,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isReminder
                          ? cs.onPrimaryContainer
                          : cs.onErrorContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    return '${diff.inDays} ngày trước';
  }
}
