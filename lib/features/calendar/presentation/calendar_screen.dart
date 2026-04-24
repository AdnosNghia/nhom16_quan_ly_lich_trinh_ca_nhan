import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../shared/widgets/app_bottom_nav.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  int _viewIndex = 0;
  final List<String> _views = ['Tháng', 'Tuần', 'Ngày'];
  final List<String> _weekdays = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.marginMobile,
              ),
              height: 64,
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
            // View Tabs
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
            // Month Header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.marginMobile,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tháng 10 năm 2024',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onBackground,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        color: AppColors.primary,
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        color: AppColors.primary,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.sm),
            // Calendar Grid
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.marginMobile,
              ),
              child: Container(
                padding: const EdgeInsets.all(AppDimensions.md),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusXl),
                ),
                child: Column(
                  children: [
                    // Weekday headers
                    Row(
                      children: List.generate(
                        _weekdays.length,
                        (index) => Expanded(
                          child: Text(
                            _weekdays[index],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.outlineVariant,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.md),
                    // Calendar days grid
                    ...List.generate(2, (row) {
                      return Padding(
                        padding:
                            const EdgeInsets.only(bottom: AppDimensions.sm),
                        child: Row(
                          children: List.generate(7, (col) {
                            final dayNum = row * 7 + col - 2;
                            final isToday = dayNum == 8;
                            final isPrevMonth = dayNum < 1;
                            return Expanded(
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: isToday
                                      ? AppColors.primaryContainer
                                          .withValues(alpha: 0.1)
                                      : null,
                                  borderRadius: BorderRadius.circular(
                                      AppDimensions.radiusMd),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      isPrevMonth
                                          ? '${28 + dayNum}'
                                          : '$dayNum',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: isToday
                                            ? FontWeight.w700
                                            : FontWeight.w400,
                                        color: isPrevMonth
                                            ? AppColors.outlineVariant
                                                .withValues(alpha: 0.3)
                                            : isToday
                                                ? AppColors.primary
                                                : AppColors.onSurface,
                                      ),
                                    ),
                                    if (dayNum == 2 || dayNum == 8)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 4),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            _dot(AppColors.primary),
                                            if (dayNum == 2)
                                              _dot(AppColors.secondary),
                                            if (dayNum == 2)
                                              _dot(AppColors.tertiary),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.md),
            // Agenda section
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.marginMobile,
                ),
                child: Column(
                  children: [
                    // Focus today card
                    Container(
                      padding: const EdgeInsets.all(AppDimensions.lg),
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer,
                        borderRadius: BorderRadius.circular(
                            AppDimensions.radiusXl),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'TẬP TRUNG HÔM NAY',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.onPrimaryContainer,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.sm),
                          const Text(
                            'Họp Sprint: Giai đoạn 2',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: AppColors.onPrimaryContainer,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.sm),
                          const Row(
                            children: [
                              Icon(Icons.schedule,
                                  size: 18,
                                  color: AppColors.onPrimaryContainer),
                              SizedBox(width: AppDimensions.sm),
                              Text(
                                '14:00 - 15:30',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.onPrimaryContainer,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDimensions.md),
                    // Timeline
                    Container(
                      padding: const EdgeInsets.all(AppDimensions.md),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(
                            AppDimensions.radiusXl),
                      ),
                      child: Column(
                        children: [
                          _timelineItem(
                            '16:00',
                            'Phản hồi khách hàng',
                            'Video Call',
                            AppColors.secondary,
                            true,
                          ),
                          const SizedBox(height: AppDimensions.sm),
                          _timelineItem(
                            '18:00',
                            'Kết thúc ngày',
                            '',
                            AppColors.outlineVariant,
                            false,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDimensions.md),
                    // Bottom sheet
                    Container(
                      padding: const EdgeInsets.all(AppDimensions.lg),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLowest,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(AppDimensions.radiusXl * 2),
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 48,
                            height: 6,
                            decoration: BoxDecoration(
                              color: AppColors.outlineVariant,
                              borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusFull),
                            ),
                          ),
                          const SizedBox(height: AppDimensions.lg),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Thứ Ba, ngày 8 tháng 10',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.onSurface,
                                    ),
                                  ),
                                  const Text(
                                    '4 Sự kiện đã lên lịch',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                              FloatingActionButton.small(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed('/add_event');
                                },
                                backgroundColor: AppColors.primary,
                                child: const Icon(Icons.add),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppDimensions.md),
                          _eventListItem(
                            'Làm việc sâu: Thiết kế UI',
                            '09:00 - 11:30',
                            AppColors.primary,
                          ),
                          const SizedBox(height: AppDimensions.sm),
                          _eventListItem(
                            'Họp nhóm',
                            '11:30 - 12:00',
                            AppColors.secondary,
                          ),
                        ],
                      ),
                    ),
                  ],
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

  Widget _dot(Color color) {
    return Container(
      width: 6,
      height: 6,
      margin: const EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _timelineItem(
    String time,
    String title,
    String subtitle,
    Color accent,
    bool isActive,
  ) {
    return Row(
      children: [
        SizedBox(
          width: 48,
          child: Text(
            time,
            style: TextStyle(
              fontSize: 12,
              color: isActive
                  ? AppColors.outline
                  : AppColors.outlineVariant,
            ),
          ),
        ),
        const SizedBox(width: AppDimensions.md),
        Expanded(
          child: isActive
              ? Container(
                  padding: const EdgeInsets.all(AppDimensions.sm + 4),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusMd),
                    border: Border(
                      left: BorderSide(color: accent, width: 4),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                )
              : const Divider(color: AppColors.outlineVariant),
        ),
      ],
    );
  }

  Widget _eventListItem(String title, String time, Color accent) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 40,
            decoration: BoxDecoration(
              color: accent,
              borderRadius: BorderRadius.circular(
                  AppDimensions.radiusFull),
            ),
          ),
          const SizedBox(width: AppDimensions.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.navigate_next,
            color: AppColors.outline,
          ),
        ],
      ),
    );
  }
}
