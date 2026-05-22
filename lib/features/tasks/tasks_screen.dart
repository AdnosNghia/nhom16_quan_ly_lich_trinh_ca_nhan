import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../shared/providers/event_provider.dart';
import '../../shared/providers/category_provider.dart';
import '../../domain/entities/event.dart';
import '../../shared/widgets/app_header.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final Set<int> _expandedQuadrants = {};

  @override
  void initState() {
    super.initState();
    context.read<EventProvider>().loadEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(),
            Expanded(
              child: Consumer<EventProvider>(
                builder: (context, eventProvider, _) {
                  final now = DateTime.now();
                  final startOfToday = DateTime(now.year, now.month, now.day);
                  final in24h = now.add(const Duration(hours: 24));
                  final in7days = now.add(const Duration(days: 7));
                  final catProvider = context.read<CategoryProvider>();
                  final delegateCat = catProvider.getCategoryByName(
                    AppStrings.delegate,
                  );

                  final delegateId = delegateCat?.id ?? '';

                  // 1. ⚡ Làm ngay: Quan trọng & Khẩn cấp
                  // - Không thuộc danh mục "Phân công"
                  // - Chưa hoàn thành
                  // - Đang diễn ra (now nằm giữa start và end) HOẶC sắp diễn ra (start trong 24h tới)
                  final doNow = eventProvider.events.where((e) {
                    if (e.categoryId == delegateId && delegateId.isNotEmpty) return false;
                    if (e.isCompleted) return false;
                    final isOngoing = e.startTime.isBefore(now) && e.endTime.isAfter(now);
                    final isUpcoming = e.startTime.isAfter(now) && e.startTime.isBefore(in24h);
                    return isOngoing || isUpcoming;
                  }).toList()
                    ..sort((a, b) => a.startTime.compareTo(b.startTime));

                  // 2. 📅 Lên lịch: Quan trọng nhưng Chưa khẩn cấp
                  // - Không thuộc danh mục "Phân công"
                  // - Chưa hoàn thành
                  // - Bắt đầu sau 24h
                  final schedule = eventProvider.events.where((e) {
                    if (e.categoryId == delegateId && delegateId.isNotEmpty) return false;
                    if (e.isCompleted) return false;
                    return e.startTime.isAfter(in24h);
                  }).toList()
                    ..sort((a, b) => a.startTime.compareTo(b.startTime));

                  // 3. 👥 Ủy thác: Danh mục "Phân công"
                  // - Bắt buộc thuộc danh mục "Phân công"
                  // - Không hiển thị việc đã quá hạn mà chưa hoàn thành
                  final delegate = eventProvider.events.where((e) {
                    if (delegateId.isEmpty || e.categoryId != delegateId) return false;
                    // Ẩn việc quá hạn chưa hoàn thành
                    if (!e.isCompleted && e.endTime.isBefore(now)) return false;
                    return true;
                  }).toList()
                    ..sort((a, b) => a.startTime.compareTo(b.startTime));

                  // 4. 🗑️ Loại bỏ / Đã bỏ lỡ
                  // - Chưa hoàn thành
                  // - Đã quá hạn (endTime < now)
                  // - Chỉ lấy các việc bỏ lỡ trong ngày hôm nay (từ 00:00)
                  final missed = eventProvider.events.where((e) {
                    return !e.isCompleted &&
                        e.endTime.isBefore(now) &&
                        e.endTime.isAfter(startOfToday);
                  }).toList()
                    ..sort((a, b) => b.endTime.compareTo(a.endTime));

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(AppDimensions.marginMobile),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.lg,
                            vertical: AppDimensions.md,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.assignment_outlined,
                                color: Theme.of(context).colorScheme.primary,
                                size: 24,
                              ),
                              const SizedBox(width: AppDimensions.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Tiến độ của bạn',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Còn ${doNow.length + schedule.length + delegate.length} công việc cần hoàn thành',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Theme.of(context).colorScheme.onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppDimensions.lg),
                        _buildQuadrant(
                          title: AppStrings.doNow,
                          icon: Icons.bolt,
                          count: '${doNow.length} Công việc',
                          bgColor: Colors.transparent,
                          bgGradient: const LinearGradient(
                            colors: [Color(0xFF0099CC), Color(0xFF0055AA)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          textColor: Colors.white,
                          borderColor: Colors.transparent,
                          events: doNow,
                          accentColor: const Color(0xFF0055AA),
                          quadrant: 0,
                          hasGlow: true,
                        ),
                        const SizedBox(height: AppDimensions.md),
                        _buildQuadrant(
                          title: AppStrings.schedule,
                          icon: Icons.calendar_month,
                          count: '${schedule.length} Công việc',
                          bgColor: Theme.of(context).colorScheme.primaryContainer,
                          textColor: Theme.of(context).colorScheme.onPrimaryContainer,
                          borderColor: Colors.transparent,
                          events: schedule,
                          accentColor: Theme.of(context).colorScheme.primary,
                          quadrant: 1,
                        ),
                        const SizedBox(height: AppDimensions.md),
                        _buildQuadrant(
                          title: AppStrings.delegate,
                          icon: Icons.group,
                          count: '${delegate.length} Công việc',
                          bgColor: Theme.of(context).colorScheme.secondaryContainer,
                          textColor: Theme.of(context).colorScheme.onSecondaryContainer,
                          borderColor: Colors.transparent,
                          events: delegate,
                          accentColor: Theme.of(context).colorScheme.secondary,
                          quadrant: 2,
                        ),
                        const SizedBox(height: AppDimensions.md),
                        _buildQuadrant(
                          title: AppStrings.eliminate,
                          icon: Icons.delete,
                          count: '${missed.length} Công việc',
                          bgColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                          textColor: Theme.of(context).colorScheme.onSurfaceVariant,
                          borderColor: Colors.transparent,
                          events: missed,
                          accentColor: Theme.of(context).colorScheme.onSurfaceVariant,
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
    );
  }

  Widget _buildQuadrant({
    required String title,
    required IconData icon,
    required String count,
    required Color bgColor,
    Gradient? bgGradient,
    required Color textColor,
    required Color borderColor,
    required List<Event> events,
    required Color accentColor,
    required int quadrant,
    bool isStrikethrough = false,
    bool hasGlow = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        border: borderColor != Colors.transparent ? Border.all(color: borderColor) : null,
        boxShadow: [
          if (hasGlow)
            BoxShadow(
              color: accentColor.withValues(alpha: 0.3),
              blurRadius: 15,
              spreadRadius: 2,
              offset: const Offset(0, 8),
            )
          else
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
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
                color: bgGradient == null ? bgColor : null,
                gradient: bgGradient,
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
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusFull,
                      ),
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
          if (events.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(AppDimensions.md),
              child: Column(
                children: [
                  ...List.generate(
                    _expandedQuadrants.contains(quadrant)
                        ? events.length
                        : events.length.clamp(0, 3),
                    (index) =>
                        _buildEventRow(events[index], accentColor, isStrikethrough),
                  ),
                  if (events.length > 3)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (_expandedQuadrants.contains(quadrant)) {
                            _expandedQuadrants.remove(quadrant);
                          } else {
                            _expandedQuadrants.add(quadrant);
                          }
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: AppDimensions.sm),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _expandedQuadrants.contains(quadrant)
                                  ? 'Thu gọn'
                                  : 'Xem thêm ${events.length - 3} công việc',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: accentColor,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              _expandedQuadrants.contains(quadrant)
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              size: 18,
                              color: accentColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
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
    final suffix = isFuture ? 'bắt đầu' : 'kết thúc';

    if (isFuture) {
      final remindMin = event.reminderMinutes.isNotEmpty
          ? event.reminderMinutes.reduce((a, b) => a < b ? a : b)
          : 15;
      if (totalMinutes < remindMin) return 'Sắp $suffix';
    } else {
      if (totalMinutes < 15) return 'Sắp $suffix';
    }

    if (totalHours < 1) return 'Trong vài phút';
    if (totalHours < 24) return 'Trong $totalHours giờ';
    final days = totalHours ~/ 24;
    return 'Trong $days ngày';
  }

  Widget _buildEventRow(Event event, Color accentColor, bool isStrikethrough) {
    final dateFormat = DateFormat('d/M/yyyy  HH:mm');
    final remaining = _formatRemainingTime(event);
    final catName = context.read<CategoryProvider>().getNameForCategory(
      event.categoryId,
    );
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
                        ? Theme.of(context).colorScheme.onSurfaceVariant
                        : Theme.of(context).colorScheme.onSurface,
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
                          ? Theme.of(context).colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.5)
                          : Theme.of(context).colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.7),
                    ),
                  ),
                if (showCategory) const SizedBox(height: 2),
                Text(
                  dateFormat.format(event.startTime),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: event.isCompleted
                        ? Theme.of(
                            context,
                          ).colorScheme.onSurfaceVariant.withValues(alpha: 0.6)
                        : Theme.of(context).colorScheme.onSurfaceVariant,
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
                          ? Theme.of(context).colorScheme.tertiary
                          : Theme.of(context).colorScheme.primary,
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
            child: Icon(
              Icons.close,
              size: 16,
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
        ],
      ),
    );
  }
}
