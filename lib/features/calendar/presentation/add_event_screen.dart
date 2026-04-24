import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _titleController = TextEditingController();
  bool _isAllDay = false;
  int _selectedReminder = 15;
  String _selectedCategory = 'Công việc';

  final List<String> _categories = ['Công việc', 'Học tập', 'Cá nhân'];
  final List<Color> _categoryColors = [
    AppColors.primary,
    AppColors.tertiary,
    AppColors.secondary,
  ];

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.marginMobile,
              ),
              height: 64,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    color: AppColors.onSurface,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Text(
                    AppStrings.addEvent,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.more_vert,
                    color: AppColors.onSurfaceVariant,
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimensions.marginMobile),
                child: Column(
                  children: [
                    // Title input
                    TextField(
                      controller: _titleController,
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: AppStrings.eventName,
                        hintStyle: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: AppColors.outlineVariant,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.lg),
                    // Date/time cards
                    Row(
                      children: [
                        Expanded(
                          child: _dateTimeCard(
                            'Bắt đầu',
                            Icons.event,
                            '15 Tháng 10, 2023',
                            '09:00 AM',
                          ),
                        ),
                        const SizedBox(width: AppDimensions.md),
                        Expanded(
                          child: _dateTimeCard(
                            'Kết thúc',
                            Icons.schedule,
                            '15 Tháng 10, 2023',
                            '10:30 AM',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.md),
                    // All day toggle
                    Container(
                      padding: const EdgeInsets.all(AppDimensions.md),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(
                            AppDimensions.radiusXl),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle_outline,
                            color: AppColors.onSurfaceVariant,
                          ),
                          const SizedBox(width: AppDimensions.md),
                          const Expanded(
                            child: Text(
                              AppStrings.allDay,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.onSurface,
                              ),
                            ),
                          ),
                          Switch(
                            value: _isAllDay,
                            onChanged: (v) =>
                                setState(() => _isAllDay = v),
                            activeTrackColor: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDimensions.md),
                    // Category
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppStrings.category.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurfaceVariant,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.sm),
                    Wrap(
                      spacing: AppDimensions.sm,
                      children: List.generate(
                        _categories.length,
                        (index) {
                          final isSelected =
                              _selectedCategory == _categories[index];
                          return ChoiceChip(
                            label: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: _categoryColors[index],
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: AppDimensions.sm),
                                Text(_categories[index]),
                              ],
                            ),
                            selected: isSelected,
                            onSelected: (v) => setState(
                                () => _selectedCategory =
                                    _categories[index]),
                            selectedColor: isSelected
                                ? _categoryColors[index]
                                    .withValues(alpha: 0.2)
                                : null,
                            side: BorderSide(
                              color: isSelected
                                  ? _categoryColors[index]
                                  : Colors.transparent,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: AppDimensions.lg),
                    // Reminder
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppStrings.reminder.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurfaceVariant,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.sm),
                    Row(
                      children: [5, 15, 30].map((minutes) {
                        final isSelected =
                            _selectedReminder == minutes;
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4),
                            child: GestureDetector(
                              onTap: () => setState(
                                  () => _selectedReminder = minutes),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(
                                        vertical: AppDimensions
                                            .sm + 4),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primaryContainer
                                      : AppColors
                                          .surfaceContainer,
                                  borderRadius: BorderRadius.circular(
                                      AppDimensions.radiusMd),
                                ),
                                child: Text(
                                  '$minutes phút',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w400,
                                    color: isSelected
                                        ? AppColors
                                            .onPrimaryContainer
                                        : AppColors.onSurface,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: AppDimensions.lg),
                    // Sub-tasks
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppStrings.subTasks.toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSurfaceVariant,
                            letterSpacing: 1,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text(AppStrings.addSubTask),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.sm),
                    _subTaskItem('Chuẩn bị tài liệu họp', false),
                    const SizedBox(height: AppDimensions.sm),
                    _subTaskItem(
                        'Gửi email mời tham gia', true),
                    const SizedBox(height: AppDimensions.sm),
                    Container(
                      padding: const EdgeInsets.all(AppDimensions.md),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(
                            AppDimensions.radiusXl),
                        border: Border.all(
                            color: AppColors.surfaceVariant),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: 'Thêm công việc khác...',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.xl),
                    // Illustration
                    Container(
                      height: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            AppDimensions.radiusXl),
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            AppColors.primary.withValues(alpha: 0.6),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 40,
                                  color: AppColors.primary
                                      .withValues(alpha: 0.5),
                                ),
                                const SizedBox(
                                    height: AppDimensions.sm),
                                const Text(
                                  'Sắp xếp ngày mới',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.onSurface,
                                  ),
                                ),
                                const Text(
                                  'Đảm bảo bạn không bỏ lỡ điều gì.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color:
                                        AppColors.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.xxl),
                  ],
                ),
              ),
            ),
            // Bottom save button
            Container(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.marginMobile,
                AppDimensions.md,
                AppDimensions.marginMobile,
                AppDimensions.md,
              ),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 16,
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.save),
                  label: const Text(AppStrings.saveEvent),
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          AppDimensions.radiusXl),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dateTimeCard(
      String label, IconData icon, String date, String time) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        border: Border.all(color: AppColors.surfaceVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              Icon(icon,
                  size: 20, color: AppColors.primary),
            ],
          ),
          const SizedBox(height: AppDimensions.sm),
          Text(
            date,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
          ),
          Text(
            time,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _subTaskItem(String title, bool completed) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        border: Border.all(color: AppColors.surfaceVariant),
      ),
      child: Row(
        children: [
          Checkbox(
            value: completed,
            onChanged: (_) {},
            activeColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(AppDimensions.radiusXs),
            ),
          ),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: completed
                    ? AppColors.onSurfaceVariant
                    : AppColors.onSurface,
                decoration: completed
                    ? TextDecoration.lineThrough
                    : null,
              ),
            ),
          ),
          const Icon(
            Icons.drag_indicator,
            color: AppColors.outlineVariant,
          ),
        ],
      ),
    );
  }
}
