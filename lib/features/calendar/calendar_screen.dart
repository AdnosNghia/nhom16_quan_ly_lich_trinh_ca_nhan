import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/helpers/responsive_helper.dart';
import '../../shared/widgets/app_bottom_nav.dart';
import '../../shared/providers/event_provider.dart';
import '../../domain/entities/event.dart';
import '../../domain/entities/subtask.dart';
import 'event_detail_screen.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  int _viewIndex = 0;
  DateTime _currentMonth = DateTime.now();
  DateTime _selectedDate = DateTime.now();
  final List<String> _views = ['Tháng', 'Tuần', 'Ngày'];
  final List<String> _weekdays = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is DateTime) {
        _selectedDate = args;
        _currentMonth = DateTime(args.year, args.month);
      }
      final provider = context.read<EventProvider>();
      provider.ensureLoaded();
      provider.loadEventsForDate(_selectedDate);
    });
  }

  int _daysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  int _firstWeekdayOfMonth(int year, int month) {
    return DateTime(year, month, 1).weekday;
  }

  DateTime _getWeekStart(DateTime date) {
    final weekday = date.weekday;
    return DateTime(date.year, date.month, date.day - (weekday - 1));
  }

  DateTime _getWeekEnd(DateTime start) {
    return start.add(const Duration(days: 6));
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
                    radius: 16,
                    backgroundColor: AppColors.surfaceContainerHighest,
                    child: const Icon(Icons.person_outline, size: 18),
                  ),
                  const SizedBox(width: AppDimensions.sm + 4),
                  const Text(
                    'Schedulr',
                    style: TextStyle(
                      fontSize: 24,
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
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.marginMobile,
              ),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusXl),
                ),
                child: Row(
                  children: List.generate(
                    _views.length,
                    (index) => Expanded(
                      child: GestureDetector(
                        onTap: () =>
                            setState(() => _viewIndex = index),
                        child: Container(
                          padding:
                              const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: _viewIndex == index
                                ? AppColors.surfaceContainerLowest
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(
                                AppDimensions.radiusMd),
                          ),
                          child: Text(
                            _views[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: _viewIndex == index
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                              color: _viewIndex == index
                                  ? AppColors.primary
                                  : AppColors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.sm),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.marginMobile,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _viewIndex == 0
                          ? 'Tháng ${_currentMonth.month} năm ${_currentMonth.year}'
                          : _viewIndex == 1
                              ? 'Tuần ${_getWeekStart(_selectedDate).day}/${_getWeekStart(_selectedDate).month} - ${_getWeekEnd(_getWeekStart(_selectedDate)).day}/${_getWeekEnd(_getWeekStart(_selectedDate)).month} năm ${_selectedDate.year}'
                              : DateFormat("EEEE, 'ngày' d 'tháng' M", 'vi_VN').format(_selectedDate),
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onBackground,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        color: AppColors.primary,
                        onPressed: () {
                          setState(() {
                            if (_viewIndex == 0) {
                              _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
                            } else if (_viewIndex == 1) {
                              _selectedDate = _selectedDate.subtract(const Duration(days: 7));
                            } else {
                              _selectedDate = _selectedDate.subtract(const Duration(days: 1));
                            }
                          });
                          if (_viewIndex != 0) {
                            context.read<EventProvider>().loadEventsForDate(_selectedDate);
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        color: AppColors.primary,
                        onPressed: () {
                          setState(() {
                            if (_viewIndex == 0) {
                              _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
                            } else if (_viewIndex == 1) {
                              _selectedDate = _selectedDate.add(const Duration(days: 7));
                            } else {
                              _selectedDate = _selectedDate.add(const Duration(days: 1));
                            }
                          });
                          if (_viewIndex != 0) {
                            context.read<EventProvider>().loadEventsForDate(_selectedDate);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.sm),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.marginMobile,
                ),
                child: Consumer<EventProvider>(
                  builder: (context, eventProvider, _) {
                    if (_viewIndex == 0) {
                      return Column(
                        children: [
                          _buildCalendarGrid(eventProvider),
                          const SizedBox(height: AppDimensions.md),
                          _buildAgendaSection(eventProvider),
                        ],
                      );
                    } else if (_viewIndex == 1) {
                      return Column(
                        children: [
                          _buildWeekView(eventProvider),
                          const SizedBox(height: AppDimensions.md),
                          _buildAgendaSection(eventProvider),
                        ],
                      );
                    } else {
                      return _buildDayView(eventProvider);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 1,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.of(context).pushReplacementNamed('/dashboard');
              break;
            case 1:
              break;
            case 2:
              Navigator.of(context).pushReplacementNamed('/tasks');
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

  Widget _buildCalendarGrid(EventProvider eventProvider) {
    final now = DateTime.now();
    final daysInMonth = _daysInMonth(_currentMonth.year, _currentMonth.month);
    final firstWeekday = _firstWeekdayOfMonth(_currentMonth.year, _currentMonth.month);
    final prevMonthDays = _daysInMonth(_currentMonth.year, _currentMonth.month - 1);

    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
      ),
      child: Column(
        children: [
          Row(
            children: List.generate(
              _weekdays.length,
              (index) => Expanded(
                child: Text(
                  _weekdays[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.scaleFont(context, 11).clamp(9, 14),
                    color: AppColors.outlineVariant,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.md),
          ...List.generate(6, (row) {
            final children = <Widget>[];
            for (int col = 0; col < 7; col++) {
              final dayNum = row * 7 + col - (firstWeekday - 2);
              final isPrevMonth = dayNum < 1;
              final isNextMonth = dayNum > daysInMonth;
              final actualDay = isPrevMonth ? prevMonthDays + dayNum : (isNextMonth ? dayNum - daysInMonth : dayNum);
              final _ = isPrevMonth
                  ? _currentMonth.month - 1
                  : isNextMonth
                      ? _currentMonth.month + 1
                      : _currentMonth.month;

              DateTime date;
              if (isPrevMonth && _currentMonth.month == 1) {
                date = DateTime(_currentMonth.year - 1, 12, actualDay);
              } else if (isNextMonth && _currentMonth.month == 12) {
                date = DateTime(_currentMonth.year + 1, 1, actualDay);
              } else if (isPrevMonth) {
                date = DateTime(_currentMonth.year, _currentMonth.month - 1, actualDay);
              } else if (isNextMonth) {
                date = DateTime(_currentMonth.year, _currentMonth.month + 1, actualDay);
              } else {
                date = DateTime(_currentMonth.year, _currentMonth.month, actualDay);
              }

              final isToday = date.year == now.year && date.month == now.month && date.day == now.day;
              final isSelected = date.year == _selectedDate.year && date.month == _selectedDate.month && date.day == _selectedDate.day;
              final eventsOnDay = eventProvider.getEventsOnDate(date);

              children.add(
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDate = date;
                        if (date.month != _currentMonth.month) {
                          _currentMonth = DateTime(date.year, date.month);
                        }
                      });
                      eventProvider.loadEventsForDate(date);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryContainer.withValues(alpha: 0.2)
                            : null,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '$actualDay',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: ResponsiveHelper.scaleFont(context, 12).clamp(10, 16),
                              fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
                              color: isPrevMonth || isNextMonth
                                  ? AppColors.outlineVariant.withValues(alpha: 0.3)
                                  : isToday
                                      ? AppColors.primary
                                      : AppColors.onSurface,
                            ),
                          ),
                          if (eventsOnDay.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: eventsOnDay.take(3).map((e) => Container(
                                  width: 5,
                                  height: 5,
                                  margin: const EdgeInsets.symmetric(horizontal: 1),
                                  decoration: BoxDecoration(
                                    color: Color(e.colorHex),
                                    shape: BoxShape.circle,
                                  ),
                                )).toList(),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.xs),
              child: Row(children: children),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildWeekView(EventProvider eventProvider) {
    final weekStart = _getWeekStart(_selectedDate);
    final now = DateTime.now();

    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
      ),
      child: Column(
        children: [
          Row(
            children: List.generate(7, (index) {
              final date = weekStart.add(Duration(days: index));
              final isToday = date.year == now.year && date.month == now.month && date.day == now.day;
              final isSelected = date.year == _selectedDate.year && date.month == _selectedDate.month && date.day == _selectedDate.day;
              final eventsOnDay = eventProvider.getEventsOnDate(date);

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() => _selectedDate = date);
                    eventProvider.loadEventsForDate(date);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryContainer.withValues(alpha: 0.3)
                          : null,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                    ),
                    child: Column(
                      children: [
                        Text(
                          _weekdays[index],
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.outlineVariant,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${date.day}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                            color: isToday
                                ? AppColors.primary
                                : AppColors.onSurface,
                          ),
                        ),
                        if (eventsOnDay.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: eventsOnDay.take(2).map((e) => Container(
                                width: 4,
                                height: 4,
                                margin: const EdgeInsets.symmetric(horizontal: 1),
                                decoration: BoxDecoration(
                                  color: Color(e.colorHex),
                                  shape: BoxShape.circle,
                                ),
                              )).toList(),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildDayView(EventProvider eventProvider) {
    return Column(
      children: [
        _buildCalendarGrid(eventProvider),
        const SizedBox(height: AppDimensions.md),
        _buildDetailedAgendaSection(eventProvider),
      ],
    );
  }

  Widget _buildAgendaSection(EventProvider eventProvider) {
    final dayEvents = eventProvider.currentDayEvents;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat("EEEE, 'ngày' d 'tháng' M", 'vi_VN').format(_selectedDate),
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                      ),
                    ),
                    Text(
                      '${dayEvents.length} Sự kiện đã lên lịch',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: AppDimensions.sm),
              if (!_selectedDate.isBefore(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)))
                FloatingActionButton.small(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/add_event', arguments: _selectedDate);
                  },
                  backgroundColor: AppColors.primary,
                  child: const Icon(Icons.add),
                ),
            ],
          ),
          const SizedBox(height: AppDimensions.md),
          if (dayEvents.isEmpty)
            Padding(
              padding: const EdgeInsets.all(AppDimensions.md),
              child: const Text(
                'Không có sự kiện nào trong ngày này.',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: AppColors.onSurfaceVariant),
              ),
            )
          else
            ...dayEvents.map((event) => Padding(
                  padding: const EdgeInsets.only(bottom: AppDimensions.sm),
                  child: _eventListItem(
                    event.title,
                    '${DateFormat('HH:mm').format(event.startTime)} - ${DateFormat('HH:mm').format(event.endTime)}',
                    Color(event.colorHex),
                    event,
                    eventProvider,
                    subtaskCount: eventProvider.currentDaySubtaskCounts[event.id] ?? 0,
                  ),
                )),
        ],
      ),
    );
  }

  Widget _buildDetailedAgendaSection(EventProvider eventProvider) {
    final dayEvents = eventProvider.currentDayEvents;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat("EEEE, 'ngày' d 'tháng' M", 'vi_VN').format(_selectedDate),
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                      ),
                    ),
                    Text(
                      '${dayEvents.length} Sự kiện - Chi tiết công việc',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: AppDimensions.sm),
              if (!_selectedDate.isBefore(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)))
                FloatingActionButton.small(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/add_event', arguments: _selectedDate);
                  },
                  backgroundColor: AppColors.primary,
                  child: const Icon(Icons.add),
                ),
            ],
          ),
          const SizedBox(height: AppDimensions.md),
          if (dayEvents.isEmpty)
            Padding(
              padding: const EdgeInsets.all(AppDimensions.md),
              child: const Text(
                'Không có sự kiện nào trong ngày này.',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: AppColors.onSurfaceVariant),
              ),
            )
          else
            ...dayEvents.map((event) => Padding(
                  padding: const EdgeInsets.only(bottom: AppDimensions.sm),
                  child: _detailedEventCard(event, eventProvider),
                )),
        ],
      ),
    );
  }

  Widget _detailedEventCard(Event event, EventProvider eventProvider) {
    return FutureBuilder<List<SubTask>>(
      future: eventProvider.getSubTasksForEvent(event.id),
      builder: (context, snapshot) {
        final subtasks = snapshot.data ?? [];
        final completedSubtasks = subtasks.where((s) => s.isCompleted).length;

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
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color(event.colorHex),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event.title,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSurface,
                            ),
                          ),
                          Text(
                            '${DateFormat('HH:mm').format(event.startTime)} - ${DateFormat('HH:mm').format(event.endTime)}',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Xóa sự kiện'),
                            content: Text('Xóa "${event.title}"?', overflow: TextOverflow.ellipsis),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Hủy')),
                              TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Xóa', style: TextStyle(color: AppColors.error))),
                            ],
                          ),
                        );
                        if (confirmed == true) {
                          await eventProvider.deleteEvent(event.id);
                        }
                      },
                      child: const Icon(Icons.delete_outline, color: AppColors.outline, size: 20),
                    ),
                  ],
                ),
                if (snapshot.connectionState == ConnectionState.waiting)
                  const Padding(
                    padding: EdgeInsets.only(top: 8, left: 8 + AppDimensions.md),
                    child: SizedBox(
                      width: 16, height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                if (subtasks.isNotEmpty) ...[
                  const SizedBox(height: AppDimensions.sm),
                  Divider(height: 1, color: AppColors.surfaceVariant.withValues(alpha: 0.5)),
                  const SizedBox(height: AppDimensions.sm),
                  Row(
                    children: [
                      Text(
                        'Công việc con ($completedSubtasks/${subtasks.length})',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: AppDimensions.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                        ),
                        child: Text(
                          '${completedSubtasks == subtasks.length ? 100 : subtasks.isEmpty ? 0 : (completedSubtasks * 100 / subtasks.length).round()}%',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.sm),
                  ...subtasks.map((subtask) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            Icon(
                              subtask.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                              size: 16,
                              color: subtask.isCompleted ? AppColors.primary : AppColors.outlineVariant,
                            ),
                            const SizedBox(width: AppDimensions.sm),
                            Expanded(
                              child: Text(
                                subtask.title,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: subtask.isCompleted ? AppColors.outlineVariant : AppColors.onSurface,
                                  decoration: subtask.isCompleted ? TextDecoration.lineThrough : null,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _eventListItem(String title, String time, Color accent, Event event, EventProvider eventProvider, {int subtaskCount = 0}) {
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
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        ),
        child: Row(
          children: [
            Container(
              width: 8,
              height: subtaskCount > 0 ? 56 : 40,
              decoration: BoxDecoration(
                color: accent,
                borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
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
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                      ),
                    ),
                    Text(
                      time,
                      overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  if (subtaskCount > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        '$subtaskCount công việc con',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Xóa sự kiện'),
                    content: Text('Xóa "${event.title}"?', overflow: TextOverflow.ellipsis),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Hủy')),
                      TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Xóa', style: TextStyle(color: AppColors.error))),
                    ],
                  ),
                );
                if (confirmed == true) {
                  await eventProvider.deleteEvent(event.id);
                }
              },
              child: const Icon(Icons.delete_outline, color: AppColors.outline, size: 20),
            ),
          ],
        ),
      ),
    );
  }

}
