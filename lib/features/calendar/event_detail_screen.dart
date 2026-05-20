import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../domain/entities/event.dart';
import '../../domain/entities/subtask.dart';
import '../../shared/providers/event_provider.dart';
import '../../shared/providers/category_provider.dart';

class EventDetailScreen extends StatefulWidget {
  final Event event;

  const EventDetailScreen({super.key, required this.event});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  late Event _event;
  List<SubTask> _subtasks = [];

  @override
  void initState() {
    super.initState();
    _event = widget.event;
    _loadSubtasks();
  }

  Future<void> _loadSubtasks() async {
    final provider = context.read<EventProvider>();
    final subtasks = await provider.getSubTasksForEvent(_event.id);
    if (mounted) {
      setState(() => _subtasks = subtasks);
    }
  }

  Future<void> _reloadEvent() async {
    final provider = context.read<EventProvider>();
    final updated = await provider.getEventById(_event.id);
    if (mounted && updated != null) {
      setState(() => _event = updated);
    }
    final subtasks = await provider.getSubTasksForEvent(_event.id);
    if (mounted) {
      setState(() => _subtasks = subtasks);
    }
  }

  Future<void> _toggleComplete() async {
    await context.read<EventProvider>().toggleEventComplete(_event.id);
    if (mounted) {
      setState(() {
        _event = _event.copyWith(isCompleted: !_event.isCompleted);
      });
    }
  }

  Future<void> _deleteEvent() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xóa sự kiện'),
        content: Text('Xóa "${_event.title}"?', overflow: TextOverflow.ellipsis),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Xóa', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await context.read<EventProvider>().deleteEvent(_event.id);
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.watch<CategoryProvider>();
    final categoryName = categoryProvider.getNameForCategory(_event.categoryId);
    final categoryColor = categoryProvider.getColorForCategory(_event.categoryId);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.marginMobile),
                child: Column(
                  children: [
                    const SizedBox(height: AppDimensions.md),
                    _buildHeroSection(categoryName, categoryColor),
                    const SizedBox(height: AppDimensions.md),
                    _buildDescriptionSection(),
                    const SizedBox(height: AppDimensions.md),
                    _buildChecklistSection(),
                    const SizedBox(height: AppDimensions.md),
                    _buildRemindersSection(),
                    const SizedBox(height: AppDimensions.md),
                    if (_event.location != null) ...[
                      _buildLocationSection(),
                      const SizedBox(height: AppDimensions.md),
                    ],
                    _buildBottomActions(),
                    const SizedBox(height: AppDimensions.xxl),
                    SizedBox(
                      height: MediaQuery.of(context).padding.bottom + 80,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.marginMobile),
      height: 64,
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
              child: const Icon(Icons.arrow_back, color: AppColors.onSurface),
            ),
          ),
          const Spacer(),
          const Text(
            'Schedulr',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          const Spacer(),
                GestureDetector(
                  onTap: () async {
                    await Navigator.pushNamed(context, '/add_event', arguments: _event);
                    if (mounted) _reloadEvent();
                  },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
              child: const Icon(Icons.edit, color: AppColors.onSurface),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(String categoryName, Color categoryColor) {
    final dayName = DateFormat("EEEE", 'vi_VN').format(_event.startTime);
    final monthDay = DateFormat("'ngày' d 'tháng' M", 'vi_VN').format(_event.startTime);
    final dateStr = '$dayName, $monthDay, ${_event.startTime.year}';
    final timeStr = '${DateFormat('HH:mm').format(_event.startTime)} - ${DateFormat('HH:mm').format(_event.endTime)}';

    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border(left: BorderSide(color: Color(_event.colorHex), width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primaryFixed,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                ),
                child: Text(
                  categoryName.isNotEmpty ? categoryName : 'Sự kiện',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.onPrimaryFixed,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.sm),
          Text(
            _event.title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: AppDimensions.sm),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 18, color: AppColors.onSurfaceVariant),
              const SizedBox(width: AppDimensions.sm),
              Text(
                dateStr,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.schedule, size: 18, color: AppColors.onSurfaceVariant),
              const SizedBox(width: AppDimensions.sm),
              Text(
                timeStr,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection() {
    if (_event.description == null || _event.description!.isEmpty) {
      return const SizedBox.shrink();
    }
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.description, size: 20, color: AppColors.primary),
              const SizedBox(width: AppDimensions.sm),
              const Text(
                'Chi tiết',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.sm),
          Text(
            _event.description!,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistSection() {
    if (_subtasks.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.checklist, size: 20, color: AppColors.primary),
              const SizedBox(width: AppDimensions.sm),
              const Text(
                'Công việc con',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.sm),
          ..._subtasks.map((subtask) => Padding(
                padding: const EdgeInsets.only(bottom: AppDimensions.sm),
                child: Row(
                  children: [
                    Icon(
                      subtask.isCompleted
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      size: 20,
                      color: subtask.isCompleted
                          ? AppColors.primary
                          : AppColors.outline,
                    ),
                    const SizedBox(width: AppDimensions.sm),
                    Expanded(
                      child: Text(
                        subtask.title,
                        style: TextStyle(
                          fontSize: 14,
                          color: subtask.isCompleted
                              ? AppColors.onSurfaceVariant
                              : AppColors.onSurface,
                          decoration: subtask.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildRemindersSection() {
    if (_event.reminderMinutes.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.notifications_active, size: 20, color: AppColors.primary),
              const SizedBox(width: AppDimensions.sm),
              const Text(
                'Nhắc nhở',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.sm),
          Wrap(
            spacing: AppDimensions.sm,
            runSpacing: AppDimensions.sm,
            children: _event.reminderMinutes.map((minutes) {
              String label;
              if (minutes < 60) {
                label = 'Trước $minutes phút';
              } else {
                label = 'Trước ${minutes ~/ 60} giờ';
              }
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
                  border: Border.all(color: AppColors.outlineVariant),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.alarm, size: 16, color: AppColors.primary),
                    const SizedBox(width: AppDimensions.xs),
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on, size: 20, color: AppColors.primary),
              const SizedBox(width: AppDimensions.sm),
              const Text(
                'Địa điểm',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.sm),
          Row(
            children: [
              Expanded(
                child: Text(
                  _event.location!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return Column(
      children: [
        GestureDetector(
          onTap: _toggleComplete,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: _event.isCompleted ? AppColors.surfaceContainerHighest : AppColors.primary,
              borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              _event.isCompleted ? 'Đánh dấu chưa hoàn thành' : 'Hoàn thành',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: _event.isCompleted ? AppColors.onSurface : AppColors.onPrimary,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.sm),
        GestureDetector(
          onTap: _deleteEvent,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.delete, size: 18, color: AppColors.secondary),
                const SizedBox(width: AppDimensions.sm),
                const Text(
                  'Xóa sự kiện',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
