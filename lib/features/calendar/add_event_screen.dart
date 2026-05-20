import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../shared/providers/event_provider.dart';
import '../../shared/providers/category_provider.dart';
import '../../domain/entities/event.dart';
import '../../domain/entities/subtask.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _subtaskController = TextEditingController();
  final _subtaskFocusNode = FocusNode();
  Event? _editingEvent;
  bool _isAllDay = false;
  int _selectedReminder = 15;
  String _selectedCategoryId = '';
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(hours: 1));
  TimeOfDay _startTime = TimeOfDay.fromDateTime(DateTime.now());
  TimeOfDay _endTime = TimeOfDay.fromDateTime(DateTime.now().add(const Duration(hours: 1)));
  final List<SubTask> _subtasks = [];
  bool _isSaving = false;

  bool get _isEditing => _editingEvent != null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Event) {
        _editingEvent = args;
        _titleController.text = args.title;
        _descriptionController.text = args.description ?? '';
        _locationController.text = args.location ?? '';
        _startDate = args.startTime;
        _endDate = args.endTime;
        _startTime = TimeOfDay.fromDateTime(args.startTime);
        _endTime = TimeOfDay.fromDateTime(args.endTime);
        _isAllDay = args.isAllDay;
        _selectedCategoryId = args.categoryId;
        _selectedReminder = args.reminderMinutes.isNotEmpty ? args.reminderMinutes.first : 15;
        setState(() {
          _subtasks.addAll(args.subtasks);
        });
      } else {
        final cats = context.read<CategoryProvider>().categories;
        if (cats.isNotEmpty) _selectedCategoryId = cats.first.id;
        if (args is DateTime) {
          setState(() {
            _startDate = args;
            _endDate = args.add(const Duration(hours: 1));
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _subtaskController.dispose();
    _subtaskFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveEvent() async {
    if (_titleController.text.trim().isEmpty) return;

    final startDateTime = DateTime(
      _startDate.year, _startDate.month, _startDate.day,
      _startTime.hour, _startTime.minute,
    );
    final endDateTime = DateTime(
      _endDate.year, _endDate.month, _endDate.day,
      _endTime.hour, _endTime.minute,
    );

    if (!_isEditing) {
      final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
      if (DateTime(startDateTime.year, startDateTime.month, startDateTime.day).isBefore(today)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không thể tạo sự kiện trong quá khứ')),
        );
        return;
      }
    }

    setState(() => _isSaving = true);

    final categoryProvider = context.read<CategoryProvider>();
    final category = categoryProvider.getCategoryById(_selectedCategoryId);

    final event = Event(
      id: _isEditing ? _editingEvent!.id : '',
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
      startTime: startDateTime,
      endTime: endDateTime,
      location: _locationController.text.trim().isEmpty ? null : _locationController.text.trim(),
      isAllDay: _isAllDay,
      categoryId: _selectedCategoryId,
      colorHex: category?.colorHex ?? (_editingEvent?.colorHex ?? 0xFF4D41DF),
      reminderMinutes: [_selectedReminder],
      subtasks: List.from(_subtasks),
    );

    if (_isEditing) {
      await context.read<EventProvider>().updateEvent(event);
    } else {
      await context.read<EventProvider>().addEvent(event);
    }

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  Future<void> _pickDateTime(bool isStart) async {
    final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    final date = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: _isEditing ? DateTime(2020) : today,
      lastDate: DateTime(2035),
    );
    if (date == null) return;
    final time = await showTimePicker(
      context: context,
      initialTime: isStart ? _startTime : _endTime,
    );
    if (time == null) return;
    setState(() {
      if (isStart) {
        _startDate = date;
        _startTime = time;
      } else {
        _endDate = date;
        _endTime = time;
      }
    });
  }

  void _addSubtask() {
    final text = _subtaskController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _subtasks.add(SubTask(title: text, sortOrder: _subtasks.length));
      _subtaskController.clear();
    });
  }

  void _toggleSubtask(int index) {
    setState(() {
      _subtasks[index] = _subtasks[index].copyWith(isCompleted: !_subtasks[index].isCompleted);
    });
  }

  String _formatDateTime(DateTime date, TimeOfDay time) {
    return '${date.day} Tháng ${date.month}, ${date.year}';
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
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
                  IconButton(
                    icon: const Icon(Icons.close),
                    color: AppColors.onSurface,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Text(
                    _isEditing ? 'Sửa Sự Kiện' : AppStrings.addEvent,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimensions.marginMobile),
                child: Column(
                  children: [
                    TextField(
                      controller: _titleController,
                      autofocus: !_isEditing,
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
                    const SizedBox(height: AppDimensions.sm),
                    TextField(
                      controller: _descriptionController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'Mô tả sự kiện...',
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.outlineVariant),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primary),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.sm),
                    TextField(
                      controller: _locationController,
                      decoration: const InputDecoration(
                        hintText: 'Địa điểm hoặc link...',
                        prefixIcon: Icon(Icons.location_on, color: AppColors.onSurfaceVariant),
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.outlineVariant),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primary),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.lg),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              _pickDateTime(true);
                            },
                            child: _dateTimeCard(
                              'Bắt đầu',
                              Icons.event,
                              _formatDateTime(_startDate, _startTime),
                              _formatTime(_startTime),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppDimensions.md),
                        const Icon(Icons.arrow_forward, color: AppColors.primary),
                        const SizedBox(width: AppDimensions.md),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              _pickDateTime(false);
                            },
                            child: _dateTimeCard(
                              'Kết thúc',
                              Icons.schedule,
                              _formatDateTime(_endDate, _endTime),
                              _formatTime(_endTime),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.md),
                    Container(
                      padding: const EdgeInsets.all(AppDimensions.md),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle_outline, color: AppColors.onSurfaceVariant),
                          const SizedBox(width: AppDimensions.md),
                          const Expanded(
                            child: Text(
                              AppStrings.allDay,
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.onSurface),
                            ),
                          ),
                          Switch(
                            value: _isAllDay,
                            onChanged: (v) => setState(() => _isAllDay = v),
                            activeTrackColor: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDimensions.md),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppStrings.category.toUpperCase(),
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.onSurfaceVariant, letterSpacing: 1),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.sm),
                    Consumer<CategoryProvider>(
                      builder: (context, categoryProvider, _) {
                        return Wrap(
                          spacing: AppDimensions.sm,
                          children: categoryProvider.categories.map((cat) {
                            final isSelected = _selectedCategoryId == cat.id;
                            return ChoiceChip(
                              label: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 12, height: 12,
                                    decoration: BoxDecoration(color: Color(cat.colorHex), shape: BoxShape.circle),
                                  ),
                                  const SizedBox(width: AppDimensions.sm),
                                  Text(cat.name),
                                ],
                              ),
                              selected: isSelected,
                              onSelected: (v) => setState(() => _selectedCategoryId = cat.id),
                              selectedColor: Color(cat.colorHex).withValues(alpha: 0.2),
                              side: BorderSide(color: isSelected ? Color(cat.colorHex) : Colors.transparent),
                            );
                          }).toList(),
                        );
                      },
                    ),
                    const SizedBox(height: AppDimensions.lg),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppStrings.reminder.toUpperCase(),
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.onSurfaceVariant, letterSpacing: 1),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.sm),
                    Row(
                      children: [5, 15, 30].map((minutes) {
                        final isSelected = _selectedReminder == minutes;
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedReminder = minutes),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: AppDimensions.sm + 4),
                                decoration: BoxDecoration(
                                  color: isSelected ? AppColors.primaryContainer : AppColors.surfaceContainer,
                                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                                ),
                                child: Text(
                                  '$minutes phút',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                                    color: isSelected ? AppColors.onPrimaryContainer : AppColors.onSurface,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: AppDimensions.lg),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppStrings.subTasks.toUpperCase(),
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.onSurfaceVariant, letterSpacing: 1),
                        ),
                        TextButton.icon(
                          onPressed: () => _subtaskFocusNode.requestFocus(),
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text(AppStrings.addSubTask),
                          style: TextButton.styleFrom(foregroundColor: AppColors.primary),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.sm),
                    ..._subtasks.asMap().entries.map((entry) => Padding(
                      padding: const EdgeInsets.only(bottom: AppDimensions.sm),
                      child: _subTaskItem(entry.value.title, entry.value.isCompleted, entry.key),
                    )),
                    Container(
                      padding: const EdgeInsets.all(AppDimensions.md),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
                        border: Border.all(color: AppColors.surfaceVariant),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _subtaskController,
                              focusNode: _subtaskFocusNode,
                              decoration: const InputDecoration(
                                hintText: 'Thêm công việc con...',
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                isDense: true,
                              ),
                              onSubmitted: (_) => _addSubtask(),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle, color: AppColors.primary),
                            onPressed: _addSubtask,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDimensions.xl),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.marginMobile, AppDimensions.md,
                AppDimensions.marginMobile, AppDimensions.md,
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
                  onPressed: _isSaving ? null : _saveEvent,
                  icon: _isSaving
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.save),
                  label: Text(_isSaving ? 'Đang lưu...' : (_isEditing ? 'Cập nhật' : AppStrings.saveEvent)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
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

  Widget _dateTimeCard(String label, IconData icon, String date, String time) {
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
              Text(label, style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
              Icon(icon, size: 20, color: AppColors.primary),
            ],
          ),
          const SizedBox(height: AppDimensions.sm),
          Text(date, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.onSurface)),
          Text(time, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14, color: AppColors.onSurfaceVariant)),
        ],
      ),
    );
  }

  Widget _subTaskItem(String title, bool completed, int index) {
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
            onChanged: (_) => _toggleSubtask(index),
            activeColor: AppColors.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusXs)),
          ),
          Expanded(
              child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                color: completed ? AppColors.onSurfaceVariant : AppColors.onSurface,
                decoration: completed ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() => _subtasks.removeAt(index));
            },
            child: const Icon(Icons.close, size: 18, color: AppColors.outlineVariant),
          ),
        ],
      ),
    );
  }
}
