import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../core/helpers/responsive_helper.dart';
import '../../shared/providers/auth_provider.dart';
import '../../shared/providers/event_provider.dart';
import '../../domain/entities/event.dart';
import '../calendar/event_detail_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DateTime _selectedDate = DateTime.now();
  late DateTime _weekStart;
  final List<String> _weekDays = ['Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7', 'CN'];

  @override
  void initState() {
    super.initState();
    _weekStart = _getWeekStart(_selectedDate);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EventProvider>().ensureLoaded();
    });
  }

  DateTime _getWeekStart(DateTime date) {
    final weekday = date.weekday;
    return DateTime(date.year, date.month, date.day - (weekday - 1));
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.marginMobile,
                vertical: AppDimensions.sm,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
                    child: const Icon(Icons.person_outline),
                  ),
                  const SizedBox(width: AppDimensions.sm + 4),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Chào buổi sáng,',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          context.watch<AuthProvider>().user?.name ?? 'Alex',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.marginMobile,
                ),
                child: Column(
                  children: [
                    _buildWeekStrip(),
                    const SizedBox(height: AppDimensions.lg),
                    _buildProgressCard(),
                    const SizedBox(height: AppDimensions.lg),
                    _buildPrioritySection(),
                    const SizedBox(height: AppDimensions.lg),
                    _buildInProgressEvents(),
                    _buildUpcomingEvents(),
                    _buildMissedEvents(),
                    const SizedBox(height: AppDimensions.xxl),
                    SizedBox(height: ResponsiveHelper.scaleWidth(context, 72).clamp(56, 96)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/add_event');
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimary),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildWeekStrip() {
    return Consumer<EventProvider>(
      builder: (context, eventProvider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tháng ${_selectedDate.month} năm ${_selectedDate.year}',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/calendar');
                  },
                  child: Text(
                    AppStrings.viewCalendar,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.sm),
            SizedBox(
              height: ResponsiveHelper.scaleHeight(context, 72).clamp(60, 100),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 7,
                separatorBuilder: (_, _) =>
                    const SizedBox(width: AppDimensions.sm + 4),
                itemBuilder: (context, index) {
                  final date = _weekStart.add(Duration(days: index));
                  final isToday = date.year == _selectedDate.year &&
                      date.month == _selectedDate.month &&
                      date.day == _selectedDate.day;
                  final dayName = _weekDays[index];
                  final eventsOnDay = eventProvider.getEventsOnDate(date);
                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedDate = date);
                    },
                    child: Container(
                      width: 60,
                      decoration: BoxDecoration(
                        color: isToday
                            ? Theme.of(context).colorScheme.primaryContainer
                            : Theme.of(context).colorScheme.surfaceContainerLow,
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusXl),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            dayName,
                            style: TextStyle(
                              fontSize: 12,
                              color: isToday
                                  ? Theme.of(context).colorScheme.onPrimaryContainer
                                      .withValues(alpha: 0.8)
                                  : Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${date.day}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: isToday
                                  ? Theme.of(context).colorScheme.onPrimaryContainer
                                  : Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                          if (eventsOnDay.isNotEmpty)
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: isToday
                                    ? Theme.of(context).colorScheme.onPrimaryContainer
                                    : Theme.of(context).colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProgressCard() {
    return Consumer<EventProvider>(
      builder: (context, eventProvider, _) {
        final todayEvents = eventProvider.getEventsOnDate(_selectedDate);
        final total = todayEvents.length;
        final completed = todayEvents.where((e) => e.isCompleted).length;
        final rate = total > 0 ? completed / total : 0.0;
        return Container(
          padding: const EdgeInsets.all(AppDimensions.lg),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
            border: Border.all(color: Theme.of(context).colorScheme.surfaceContainer),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.progressToday,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.xs),
                    Text(
                      AppStrings.progressDesc,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.sm),
                    Text.rich(
                      TextSpan(
                        text: '$completed ',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        children: [
                          TextSpan(
                            text: 'trên $total công việc',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                        width: AppDimensions.progressCircleSize(context),
                        height: AppDimensions.progressCircleSize(context),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: AppDimensions.progressCircleSize(context),
                              height: AppDimensions.progressCircleSize(context),
                              child: CircularProgressIndicator(
                        value: rate,
                        strokeWidth: 8,
                        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.primary),
                      ),
                    ),
                    Text(
                      '${(rate * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPrioritySection() {
    return Consumer<EventProvider>(
      builder: (context, eventProvider, _) {
        final now = DateTime.now();
        final in24h = now.add(const Duration(hours: 24));
        // Priority events: not completed, starting within 24h or currently active
        final priorityEvents = eventProvider.getEventsOnDate(_selectedDate).where((e) {
          if (e.isCompleted) return false;
          return (e.startTime.isAfter(now) && e.startTime.isBefore(in24h))
              || (e.startTime.isBefore(now) && e.endTime.isAfter(now));
        }).take(3).toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.priorityTasks,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/tasks');
                  },
                  child: Text(
                    AppStrings.viewAll,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.sm),
            if (priorityEvents.isEmpty)
              Container(
                padding: const EdgeInsets.all(AppDimensions.md),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
                ),
                child: Text(
                  'Không có công việc ưu tiên nào trong ngày này.',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              )
            else
              ...priorityEvents.map((event) => Padding(
                    padding: const EdgeInsets.only(bottom: AppDimensions.sm),
                    child: _buildPriorityEventCard(
                      event: event,
                      title: event.title,
                      badge: event.startTime.isBefore(now) ? 'Đang diễn ra' : 'Sắp tới',
                      icon: event.startTime.isBefore(now) ? Icons.bolt : Icons.calendar_month,
                      time: '${DateFormat('HH:mm').format(event.startTime)} - ${DateFormat('HH:mm').format(event.endTime)}',
                      accentColor: event.startTime.isBefore(now) ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary,
                    ),
                  )),
          ],
        );
      },
    );
  }

  Widget _buildPriorityEventCard({
    required Event event,
    required String title,
    required String badge,
    required IconData icon,
    required String time,
    required Color accentColor,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => EventDetailScreen(event: event),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.md),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
          border: Border(left: BorderSide(color: accentColor, width: 4)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                context.read<EventProvider>().toggleEventComplete(event.id);
              },
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: event.isCompleted ? accentColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                  border: Border.all(color: accentColor),
                ),
                child: event.isCompleted
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : null,
              ),
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
                      fontWeight: FontWeight.w700,
                      color: event.isCompleted
                          ? Theme.of(context).colorScheme.onSurfaceVariant
                          : Theme.of(context).colorScheme.onSurface,
                      decoration: event.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  if (!event.isCompleted) ...[
                    const SizedBox(height: AppDimensions.xs),
                    Row(
                      children: [
                        Icon(icon, size: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
                        const SizedBox(width: 4),
                        Text(
                          time,
                          style: TextStyle(
                            fontSize: 10,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInProgressEvents() {
    return Consumer<EventProvider>(
      builder: (context, eventProvider, _) {
        final now = DateTime.now();
        final inProgress = eventProvider.getEventsOnDate(_selectedDate)
            .where((e) => e.startTime.isBefore(now) && e.endTime.isAfter(now))
            .toList();
        if (inProgress.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(bottom: AppDimensions.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.play_circle_filled, size: 20, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: AppDimensions.sm),
                  Text(
                    'Đang diễn ra',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.sm),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                    ),
                    child: Text(
                      '${inProgress.length}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.sm),
              ...inProgress.map((event) => Padding(
                    padding: const EdgeInsets.only(bottom: AppDimensions.sm),
                    child: _buildEventCard(
                      event: event,
                      month: DateFormat('MMM').format(event.startTime).toUpperCase(),
                      day: '${event.startTime.day}',
                      title: event.title,
                      subtitle: '${DateFormat('HH:mm').format(event.startTime)} - ${DateFormat('HH:mm').format(event.endTime)}',
                      accent: Color(event.colorHex),
                    ),
                  )),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUpcomingEvents() {
    return Consumer<EventProvider>(
      builder: (context, eventProvider, _) {
        final now = DateTime.now();
        final dayEvents = eventProvider.getEventsOnDate(_selectedDate)
            .where((e) => e.startTime.isAfter(now))
            .toList();
            
        if (dayEvents.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.upcomingEvents,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppDimensions.sm),
            ...dayEvents.map((event) => Padding(
                  padding: const EdgeInsets.only(bottom: AppDimensions.sm),
                  child: _buildEventCard(
                    event: event,
                    month: DateFormat('MMM').format(event.startTime).toUpperCase(),
                    day: '${event.startTime.day}',
                    title: event.title,
                    subtitle: '${DateFormat('HH:mm').format(event.startTime)} - ${DateFormat('HH:mm').format(event.endTime)}',
                    accent: Color(event.colorHex),
                    ),
                  )),
          ],
        );
      },
    );
  }

  Widget _buildMissedEvents() {
    return Consumer<EventProvider>(
      builder: (context, eventProvider, _) {
        final now = DateTime.now();
        final missed = eventProvider.getEventsOnDate(_selectedDate)
            .where((e) => e.endTime.isBefore(now))
            .toList();
        if (missed.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(top: AppDimensions.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.error_outline, size: 20, color: Theme.of(context).colorScheme.error),
                  const SizedBox(width: AppDimensions.sm),
                  Text(
                    'Đã bỏ lỡ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.sm),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                    ),
                    child: Text(
                      '${missed.length}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.sm),
              ...missed.map((event) => Padding(
                    padding: const EdgeInsets.only(bottom: AppDimensions.sm),
                    child: _buildMissedEventCard(
                      event: event,
                      month: DateFormat('MMM').format(event.startTime).toUpperCase(),
                      day: '${event.startTime.day}',
                      title: event.title,
                      subtitle: '${DateFormat('HH:mm').format(event.startTime)} - ${DateFormat('HH:mm').format(event.endTime)}',
                      accent: Color(event.colorHex),
                    ),
                  )),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEventCard({
    required Event event,
    required String month,
    required String day,
    required String title,
    required String subtitle,
    required Color accent,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => EventDetailScreen(event: event),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.md),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        ),
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
                  color: event.isCompleted ? Theme.of(context).colorScheme.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                  border: Border.all(color: Theme.of(context).colorScheme.primary),
                ),
                child: event.isCompleted
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : null,
              ),
            ),
            const SizedBox(width: AppDimensions.sm + 4),
            Container(
              width: 48,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerLowest,
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusMd),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    month,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: accent,
                    ),
                  ),
                  Text(
                    day,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
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
                      fontWeight: FontWeight.w700,
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
            Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMissedEventCard({
    required Event event,
    required String month,
    required String day,
    required String title,
    required String subtitle,
    required Color accent,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => EventDetailScreen(event: event),
          ),
        );
      },
      child: Opacity(
        opacity: 0.6,
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.md),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
            border: Border.all(color: Theme.of(context).colorScheme.error.withValues(alpha: 0.3)),
          ),
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
                    color: event.isCompleted ? Theme.of(context).colorScheme.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                    border: Border.all(color: Theme.of(context).colorScheme.primary),
                  ),
                  child: event.isCompleted
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(width: AppDimensions.sm + 4),
              Container(
                width: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerLowest,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusMd),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      month,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: accent.withValues(alpha: 0.5),
                      ),
                    ),
                    Text(
                      day,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
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
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    Text(
                      subtitle,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.read<EventProvider>().toggleEventComplete(event.id);
                },
                child: Icon(
                  Icons.access_time_filled,
                  size: 16,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
