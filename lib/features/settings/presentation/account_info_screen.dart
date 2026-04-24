import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

class AccountInfoScreen extends StatelessWidget {
  const AccountInfoScreen({super.key});

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
          'Hồ sơ cá nhân',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            color: AppColors.primary,
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.marginMobile),
        child: Column(
          children: [
            const SizedBox(height: AppDimensions.md),
            // Profile avatar
            Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: AppColors.primaryContainer,
                  child: const Icon(
                    Icons.person,
                    size: 60,
                    color: AppColors.onPrimaryContainer,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.photo_camera,
                      size: 20,
                      color: AppColors.onPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.md),
            const Text(
              'Nguyễn Minh Tuấn',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
            const Text(
              'Sinh viên năm 3 • Đại học Bách Khoa',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppDimensions.xl),
            // Info cards grid
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(AppDimensions.lg),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(
                          AppDimensions.radiusXl),
                      border: Border.all(
                        color: AppColors.surfaceVariant,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Thông tin cơ bản',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                'Chỉnh sửa',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        _infoField(
                            'Email', 'minhtuan.nguyen@example.com'),
                        _infoField(
                            'Số điện thoại', '+84 987 654 321'),
                        _infoField(
                            'Địa chỉ', 'Quận 1, TP. Hồ Chí Minh'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: AppDimensions.md),
                Expanded(
                  child: Container(
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
                          'Tiến độ tuần này',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: AppColors.onPrimaryContainer,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.xs),
                        const Text(
                          'Bạn đã hoàn thành 85% mục tiêu đã đề ra.',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.onPrimaryContainer,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.md),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                              AppDimensions.radiusFull),
                          child: const LinearProgressIndicator(
                            value: 0.85,
                            backgroundColor:
                                AppColors.onPrimaryContainer,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.surfaceContainerLowest,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppDimensions.md),
                        SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              backgroundColor:
                                  AppColors.surfaceContainerLowest,
                              foregroundColor: AppColors.primary,
                            ),
                            child: const Text('Xem chi tiết'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.md),
            // Security section
            Container(
              padding: const EdgeInsets.all(AppDimensions.lg),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusXl),
                border:
                    Border.all(color: AppColors.surfaceVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bảo mật & Tài khoản',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.md),
                  Wrap(
                    spacing: AppDimensions.md,
                    runSpacing: AppDimensions.md,
                    children: [
                      _securityButton(Icons.lock_outlined,
                          'Đổi mật khẩu', 'Cập nhật mật khẩu mới'),
                      _securityButton(Icons.verified_user_outlined,
                          'Xác thực 2 lớp', 'Bảo vệ tài khoản'),
                      _securityButton(Icons.history_outlined,
                          'Lịch sử đăng nhập', 'Kiểm tra thiết bị'),
                      _securityButton(Icons.logout, 'Đăng xuất',
                          'Kết thúc phiên làm việc',
                          isDestructive: true),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.md),
            // Preferences
            Container(
              padding: const EdgeInsets.all(AppDimensions.lg),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusXl),
                border:
                    Border.all(color: AppColors.surfaceVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tùy chỉnh ứng dụng',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.md),
                  _preferenceItem(
                    Icons.dark_mode_outlined,
                    'Chế độ tối (Dark Mode)',
                    trailing: Switch(
                      value: false,
                      onChanged: (_) {},
                      activeTrackColor: AppColors.primary,
                    ),
                  ),
                  _preferenceItem(
                    Icons.language_outlined,
                    'Ngôn ngữ',
                    trailing: const Text(
                      'Tiếng Việt',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.xxl),
          ],
        ),
      ),
    );
  }

  Widget _infoField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _securityButton(
      IconData icon, String title, String subtitle,
      {bool isDestructive = false}) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        border: Border.all(
          color: isDestructive
              ? AppColors.error.withValues(alpha: 0.2)
              : AppColors.outlineVariant,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        color: isDestructive
            ? AppColors.errorContainer.withValues(alpha: 0.1)
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isDestructive
                  ? AppColors.error
                  : AppColors.secondaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(icon,
                color: isDestructive
                    ? AppColors.onError
                    : AppColors.onSecondaryContainer,
                size: 20),
          ),
          const SizedBox(width: AppDimensions.sm + 4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDestructive
                      ? AppColors.error
                      : AppColors.onSurface,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 10,
                  color: isDestructive
                      ? AppColors.error.withValues(alpha: 0.7)
                      : AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _preferenceItem(
      IconData icon, String title, {Widget? trailing}) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.md,
        vertical: AppDimensions.sm + 4,
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.onSurfaceVariant),
          const SizedBox(width: AppDimensions.md),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface,
              ),
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }
}
