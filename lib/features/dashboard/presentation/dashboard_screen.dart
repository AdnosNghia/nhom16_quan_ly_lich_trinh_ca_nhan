import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../shared/widgets/app_bottom_nav.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<String> _weekDays = ['Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7', 'CN'];
  final List<int> _weekDates = [15, 16, 17, 18, 19, 20, 21];

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
                vertical: AppDimensions.sm,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.surfaceContainer,
                    child: const Icon(Icons.person_outline),
                  ),
                  const SizedBox(width: AppDimensions.sm + 4),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Chào buổi sáng,',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        'Alex',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    color: AppColors.onSurfaceVariant,
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
                    // Week Strip
                    _buildWeekStrip(),
                    const SizedBox(height: AppDimensions.lg),
                    // Progress Card
                    _buildProgressCard(),
                    const SizedBox(height: AppDimensions.lg),
                    // Priority Tasks
                    _buildPrioritySection(),
                    const SizedBox(height: AppDimensions.lg),
                    // Upcoming Events
                    _buildUpcomingEvents(),
                    const SizedBox(height: AppDimensions.xxl),
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
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.onPrimary),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: AppBottomNav(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              break;
            case 1:
              Navigator.of(context).pushReplacementNamed('/calendar');
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

  Widget _buildWeekStrip() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Tháng 4 năm 2024',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                AppStrings.viewCalendar,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.sm),
        SizedBox(
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _weekDays.length,
            separatorBuilder: (_, __) =>
                const SizedBox(width: AppDimensions.sm + 4),
            itemBuilder: (context, index) {
              final isToday = index == 2;
              return Container(
                width: 60,
                decoration: BoxDecoration(
                  color: isToday
                      ? AppColors.primaryContainer
                      : AppColors.surfaceContainerLow,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusXl),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _weekDays[index],
                      style: TextStyle(
                        fontSize: 12,
                        color: isToday
                            ? AppColors.onPrimaryContainer
                                .withValues(alpha: 0.8)
                            : AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_weekDates[index]}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: isToday
                            ? AppColors.onPrimaryContainer
                            : AppColors.onSurfaceVariant,
                      ),
                    ),
                    if (isToday)
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppColors.onPrimaryContainer,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProgressCard() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        border: Border.all(color: AppColors.surfaceContainer),
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
                const Text(
                  AppStrings.progressToday,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: AppDimensions.xs),
                const Text(
                  AppStrings.progressDesc,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppDimensions.sm),
                const Text.rich(
                  TextSpan(
                    text: '8 ',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                    children: [
                      TextSpan(
                        text: 'trên 12 công việc',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 96,
            height: 96,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 96,
                  height: 96,
                  child: CircularProgressIndicator(
                    value: 0.66,
                    strokeWidth: 8,
                    backgroundColor: AppColors.surfaceContainer,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.primary),
                  ),
                ),
                const Text(
                  '66%',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrioritySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              AppStrings.priorityTasks,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                AppStrings.viewAll,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.sm),
        _buildTaskCard(
          'Đánh giá tài chính quý',
          'ƯU TIÊN CAO',
          Icons.schedule,
          '10:00 AM',
          AppColors.secondary,
          AppColors.secondaryFixed,
        ),
        const SizedBox(height: AppDimensions.sm),
        _buildTaskCard(
          'Cuộc gọi định hướng khách hàng',
          'CÔNG VIỆC',
          Icons.schedule,
          '2:30 PM',
          AppColors.primary,
          AppColors.primaryFixed,
        ),
      ],
    );
  }

  Widget _buildTaskCard(
    String title,
    String badge,
    IconData icon,
    String time,
    Color accentColor,
    Color badgeBg,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
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
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              border: Border.all(
                  color: AppColors.secondaryContainer),
              borderRadius:
                  BorderRadius.circular(AppDimensions.radiusXs),
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
                const SizedBox(height: AppDimensions.xs),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: badgeBg,
                        borderRadius: BorderRadius.circular(
                            AppDimensions.radiusFull),
                      ),
                      child: Text(
                        badge,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSecondaryFixedVariant,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.sm),
                    Icon(icon, size: 12, color: AppColors.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingEvents() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          AppStrings.upcomingEvents,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: AppDimensions.sm),
        _buildEventCard(
          'TH4',
          '18',
          'Họp chiến lược sản phẩm',
          'Họp trực tuyến • 09:00 - 10:00',
          AppColors.secondary,
        ),
        const SizedBox(height: AppDimensions.sm),
        _buildEventCard(
          'TH4',
          '20',
          'Ăn trưa cùng nhóm',
          'The Greenhouse Cafe • 12:30 - 14:00',
          AppColors.tertiary,
        ),
      ],
    );
  }

  Widget _buildEventCard(
    String month,
    String day,
    String title,
    String subtitle,
    Color accent,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius:
                  BorderRadius.circular(AppDimensions.radiusMd),
            ),
            child: Column(
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
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
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
          ),
          const Icon(
            Icons.chevron_right,
            color: AppColors.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}
