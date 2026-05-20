import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../shared/widgets/app_bottom_nav.dart';
import '../../shared/providers/event_provider.dart';
import '../../shared/providers/category_provider.dart';
import '../../domain/entities/event.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  @override
  void initState() {
    super.initState();
    context.read<EventProvider>().loadEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.marginMobile,
              ),
              height: AppDimensions.headerHeight(context),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.surfaceContainer,
                    child: const Icon(Icons.person_outline),
                  ),
                  const SizedBox(width: AppDimensions.sm + 4),
                  const Text(
                    'Schedulr',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    color: AppColors.primary,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            Expanded(
              child: Consumer<EventProvider>(
                builder: (context, eventProvider, _) {
                  final now = DateTime.now();
                  final startOfToday = DateTime(now.year, now.month, now.day);
                  final in24h = now.add(const Duration(hours: 24));
                  final in7days = now.add(const Duration(days: 7));
                  final catProvider = context.read<CategoryProvider>();
                  final delegateCat = catProvider.getCategoryByName(AppStrings.delegate);

                  final delegateId = delegateCat?.id ?? '';
                  final doNow = eventProvider.events.where((e) {
                    if (e.categoryId == delegateId) return false;
                    if (e.isCompleted && e.endTime.isBefore(now)) return true;
                    return (e.startTime.isAfter(now) && e.startTime.isBefore(in24h))
                        || (e.startTime.isBefore(now) && e.endTime.isAfter(now));
                  }).toList();
                  final schedule = eventProvider.events.where((e) {
                    if (e.categoryId == delegateId) return false;
                    if (e.isCompleted) return false;
                    return e.startTime.isAfter(in24h) && e.startTime.isBefore(in7days);
                  }).toList();
                  final delegate = eventProvider.events.where((e) {
                    if (e.categoryId != delegateId) return false;
                    if (!e.isCompleted && e.endTime.isBefore(now)) return false;
                    return true;
                  }).toList();
                  final missed = eventProvider.events.where((e) {
                    return !e.isCompleted && e.endTime.isBefore(now) && e.endTime.isAfter(startOfToday);
                  }).toList();

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(AppDimensions.marginMobile),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          AppStrings.eisenhowerTitle,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: AppColors.onSurface,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.xs),
                        Text(
                          AppStrings.eisenhowerDesc,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.lg),
                        _buildQuadrant(
                          title: AppStrings.doNow,
                          icon: Icons.bolt,
                          count: '${doNow.length} Công việc',
                          bgColor: AppColors.primary,
                          textColor: AppColors.onPrimary,
                          borderColor: AppColors.primary.withValues(alpha: 0.1),
                          events: doNow,
                          accentColor: AppColors.primary,
                          quadrant: 0,
                        ),
                        const SizedBox(height: AppDimensions.md),
                        _buildQuadrant(
                          title: AppStrings.schedule,
                          icon: Icons.calendar_month,
                          count: '${schedule.length} Công việc',
                          bgColor: AppColors.secondary,
                          textColor: AppColors.onSecondary,
                          borderColor: AppColors.secondary.withValues(alpha: 0.1),
                          events: schedule,
                          accentColor: AppColors.secondary,
                          quadrant: 1,
                        ),
                        const SizedBox(height: AppDimensions.md),
                        _buildQuadrant(
                          title: AppStrings.delegate,
                          icon: Icons.group,
                          count: '${delegate.length} Công việc',
                          bgColor: AppColors.tertiary,
                          textColor: AppColors.onTertiary,
                          borderColor: AppColors.tertiary.withValues(alpha: 0.1),
                          events: delegate,
                          accentColor: AppColors.tertiary,
                          quadrant: 2,
                        ),
                        const SizedBox(height: AppDimensions.md),
                        _buildQuadrant(
                          title: AppStrings.eliminate,
                          icon: Icons.delete,
                          count: '${missed.length} Công việc',
                          bgColor: AppColors.surfaceContainerHighest,
                          textColor: AppColors.onSurfaceVariant,
                          borderColor: AppColors.outlineVariant,
                          events: missed,
                          accentColor: AppColors.outline,
                          quadrant: 3,
                          isStrikethrough: true,
                        ),
                        const SizedBox(height: AppDimensions.xxl),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.of(context).pushReplacementNamed('/dashboard');
              break;
            case 1:
              Navigator.of(context).pushReplacementNamed('/calendar');
              break;
            case 2:
              break;
            case 3:
              Navigator.of(context).pushReplacementNamed('/analytics');
              break;
            case 4:
              Navigator.of(context).pushReplacementNamed('/settings');
              break;
          }
        },
      ),
    );
  }

  Widget _buildQuadrant({
    required String title,
    required IconData icon,
    required String count,
    required Color bgColor,
    required Color textColor,
    required Color borderColor,
    required List<Event> events,
    required Color accentColor,
    required int quadrant,
    bool isStrikethrough = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed('/add_event');
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimensions.md),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppDimensions.radiusXl),
                ),
              ),
              child: Row(
                children: [
                  Icon(icon, color: textColor, size: 20),
                  const SizedBox(width: AppDimensions.sm),
                  Expanded(
                    child: Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.sm,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: textColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                    ),
                    child: Text(
                      count,
                      style: TextStyle(fontSize: 12, color: textColor),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.sm),
                  Icon(Icons.add_circle, color: textColor, size: 20),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppDimensions.md),
            child: Column(
              children: List.generate(
                events.length,
                (index) => _buildEventRow(events[index], accentColor, isStrikethrough),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatRemainingTime(Event event) {
    final now = DateTime.now();
    if (event.isCompleted) return '';

    DateTime target;
    final bool isFuture = event.startTime.isAfter(now);
    if (isFuture) {
      target = event.startTime;
    } else if (event.endTime.isAfter(now)) {
      target = event.endTime;
    } else {
      return '';
    }

    final diff = target.difference(now);
    final totalMinutes = diff.inMinutes;
    final totalHours = diff.inHours;
    final suffix = isFuture ? 'sẽ bắt đầu' : 'sẽ kết thúc';

    if (isFuture) {
      final remindMin = event.reminderMinutes.isNotEmpty
          ? event.reminderMinutes.reduce((a, b) => a < b ? a : b)
          : 15;
      if (totalMinutes < remindMin) return 'Sắp $suffix';
    } else {
      if (totalMinutes < 15) return 'Sắp $suffix';
    }

    if (totalHours < 1) return 'Chưa đầy 1h nữa $suffix';
    if (totalHours < 24) return 'còn $totalHours giờ nữa $suffix';
    final days = totalHours ~/ 24;
    final hours = totalHours % 24;
    if (hours == 0) return 'còn $days ngày nữa $suffix';
    return 'còn $days ngày $hours giờ nữa $suffix';
  }

  Widget _buildEventRow(Event event, Color accentColor, bool isStrikethrough) {
    final dateFormat = DateFormat('d/M/yyyy  HH:mm');
    final remaining = _formatRemainingTime(event);
    final catName = context.read<CategoryProvider>().getNameForCategory(event.categoryId);
    final showCategory = isStrikethrough && catName.isNotEmpty;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.sm),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              context.read<EventProvider>().toggleEventComplete(event.id);
            },
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: event.isCompleted ? accentColor : Colors.transparent,
                borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                border: Border.all(color: accentColor),
              ),
              child: event.isCompleted
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(width: AppDimensions.sm + 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isStrikethrough || event.isCompleted
                        ? AppColors.onSurfaceVariant
                        : AppColors.onSurface,
                    decoration: isStrikethrough || event.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                const SizedBox(height: 2),
                if (showCategory)
                  Text(
                    catName,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      color: event.isCompleted
                          ? AppColors.onSurfaceVariant.withValues(alpha: 0.5)
                          : AppColors.onSurfaceVariant.withValues(alpha: 0.7),
                    ),
                  ),
                if (showCategory) const SizedBox(height: 2),
                Text(
                  dateFormat.format(event.startTime),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: event.isCompleted
                        ? AppColors.onSurfaceVariant.withValues(alpha: 0.6)
                        : AppColors.onSurfaceVariant,
                  ),
                ),
                if (remaining.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    remaining,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: remaining.startsWith('còn')
                          ? AppColors.tertiary
                          : AppColors.primary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              context.read<EventProvider>().deleteEvent(event.id);
            },
            child: const Icon(Icons.close, size: 16, color: AppColors.outlineVariant),
          ),
        ],
      ),
    );
  }
}
