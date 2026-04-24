import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../shared/widgets/app_bottom_nav.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

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
              child: SingleChildScrollView(
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
                    // 2x2 Grid
                    _buildQuadrant(
                      title: AppStrings.doNow,
                      icon: Icons.bolt,
                      count: '4 Công việc',
                      bgColor: AppColors.primary,
                      textColor: AppColors.onPrimary,
                      borderColor: AppColors.primary.withValues(alpha: 0.1),
                      tasks: const [
                        'Hoàn thiện đề xuất dự án Q3',
                        'Cuộc gọi khẩn cấp từ khách hàng',
                        'Server Migration Prep',
                      ],
                      accentColor: AppColors.primary,
                    ),
                    const SizedBox(height: AppDimensions.md),
                    _buildQuadrant(
                      title: AppStrings.schedule,
                      icon: Icons.calendar_month,
                      count: '2 Công việc',
                      bgColor: AppColors.secondary,
                      textColor: AppColors.onSecondary,
                      borderColor: AppColors.secondary.withValues(alpha: 0.1),
                      tasks: const [
                        'Đánh giá tăng trưởng hàng tuần',
                        'Tiệc tối giao lưu',
                      ],
                      accentColor: AppColors.secondary,
                    ),
                    const SizedBox(height: AppDimensions.md),
                    _buildQuadrant(
                      title: AppStrings.delegate,
                      icon: Icons.group,
                      count: '3 Công việc',
                      bgColor: AppColors.tertiary,
                      textColor: AppColors.onTertiary,
                      borderColor: AppColors.tertiary.withValues(alpha: 0.1),
                      tasks: const [
                        'Đặt vé du lịch cho Hội chợ',
                        'Phản hồi mạng xã hội',
                      ],
                      accentColor: AppColors.tertiary,
                    ),
                    const SizedBox(height: AppDimensions.md),
                    _buildQuadrant(
                      title: AppStrings.eliminate,
                      icon: Icons.delete,
                      count: '1 Công việc',
                      bgColor: AppColors.surfaceContainerHighest,
                      textColor: AppColors.onSurfaceVariant,
                      borderColor: AppColors.outlineVariant,
                      tasks: const [
                        'Dọn dẹp công việc ưu tiên thấp',
                      ],
                      accentColor: AppColors.outline,
                      isStrikethrough: true,
                    ),
                    const SizedBox(height: AppDimensions.xxl),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
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
    required List<String> tasks,
    required Color accentColor,
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
          Container(
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
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: textColor,
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
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusFull),
                  ),
                  child: Text(
                    count,
                    style: TextStyle(
                      fontSize: 12,
                      color: textColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppDimensions.md),
            child: Column(
              children: List.generate(
                tasks.length,
                (index) => Padding(
                  padding:
                      const EdgeInsets.only(bottom: AppDimensions.sm),
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              AppDimensions.radiusXs),
                          border: Border.all(color: accentColor),
                        ),
                      ),
                      const SizedBox(width: AppDimensions.sm + 4),
                      Text(
                        tasks[index],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isStrikethrough
                              ? AppColors.onSurfaceVariant
                              : AppColors.onSurface,
                          decoration: isStrikethrough
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
