import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../shared/widgets/app_toggle.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool _pushEnabled = true;
  bool _soundEnabled = true;
  bool _reminderEnabled = true;
  bool _weeklyReportEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Thông báo',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.surfaceContainer,
              child: const Icon(Icons.person_outline, size: 20),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.marginMobile),
        child: Column(
          children: [
            // Hero card
            Container(
              padding: const EdgeInsets.all(AppDimensions.lg),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusXl),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppDimensions.sm + 4),
                    decoration: BoxDecoration(
                      color: AppColors.onPrimaryContainer.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(
                          AppDimensions.radiusMd),
                    ),
                    child: const Icon(
                      Icons.notifications_active,
                      size: 28,
                      color: AppColors.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.md),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quản lý tùy chọn',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onPrimaryContainer,
                          ),
                        ),
                        Text(
                          'Tùy chỉnh cách bạn nhận thông báo từ Schedulr.',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.onPrimaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.lg),
            // General settings
            _settingsGroup('Cài đặt chung', [
              _toggleItem(
                Icons.cell_tower,
                'Thông báo đẩy',
                'Nhận thông báo tức thì trên màn hình khóa',
                _pushEnabled,
                (v) => setState(() => _pushEnabled = v),
              ),
              _toggleItem(
                Icons.volume_up,
                'Âm báo',
                'Phát âm thanh khi có thông báo mới',
                _soundEnabled,
                (v) => setState(() => _soundEnabled = v),
              ),
            ]),
            const SizedBox(height: AppDimensions.md),
            // Event settings
            _settingsGroup('Sự kiện & Lịch', [
              _toggleItem(
                Icons.event_note,
                'Nhắc nhở trước sự kiện',
                'Thông báo 15 phút trước khi bắt đầu',
                _reminderEnabled,
                (v) => setState(() => _reminderEnabled = v),
              ),
              _toggleItem(
                Icons.analytics,
                'Báo cáo hàng tuần',
                'Tổng kết năng suất vào sáng Thứ Hai',
                _weeklyReportEnabled,
                (v) => setState(() => _weeklyReportEnabled = v),
              ),
            ]),
            const SizedBox(height: AppDimensions.md),
            // Quick settings cards
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(AppDimensions.lg),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(
                          AppDimensions.radiusXl),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.schedule,
                            color: AppColors.primary, size: 28),
                        SizedBox(height: AppDimensions.sm),
                        Text(
                          'Giờ yên tĩnh',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSurface,
                          ),
                        ),
                        Text(
                          'Tạm dừng tất cả thông báo.',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: AppDimensions.md),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(AppDimensions.lg),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryContainer,
                      borderRadius: BorderRadius.circular(
                          AppDimensions.radiusXl),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.emergency,
                            color: AppColors.onSecondaryContainer,
                            size: 28),
                        SizedBox(height: AppDimensions.sm),
                        Text(
                          'Ưu tiên khẩn cấp',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSecondaryContainer,
                          ),
                        ),
                        Text(
                          'Bỏ qua chế độ im lặng.',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.onSecondaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.xxl),
          ],
        ),
      ),
    );
  }

  Widget _settingsGroup(String title, List<Widget> items) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.md,
              AppDimensions.sm + 4,
              AppDimensions.md,
              AppDimensions.sm,
            ),
            child: Text(
              title.toUpperCase(),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
                letterSpacing: 1,
              ),
            ),
          ),
          ...items,
        ],
      ),
    );
  }

  Widget _toggleItem(
    IconData icon,
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.md),
        margin: const EdgeInsets.only(bottom: AppDimensions.xs),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.primary, size: 22),
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
                      fontWeight: FontWeight.w600,
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
            AppToggle(value: value, onChanged: onChanged),
          ],
        ),
      ),
    );
  }
}
