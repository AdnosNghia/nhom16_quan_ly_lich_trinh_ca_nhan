import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../core/constants/app_dimensions.dart';
import '../../core/helpers/responsive_helper.dart';
import '../../shared/providers/auth_provider.dart';
import '../../shared/providers/event_provider.dart';
import '../../shared/providers/theme_provider.dart';
import '../../domain/entities/user.dart';

class AccountInfoScreen extends StatelessWidget {
  const AccountInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final user = authProvider.user;
    final firebaseUser = authProvider.firebaseUser;
    
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Hồ sơ cá nhân',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            color: Theme.of(context).colorScheme.primary,
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
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.photo_camera,
                      size: 20,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.md),
            Text(
              user?.name ?? 'Người dùng',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            Text(
              user?.email ?? '',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppDimensions.xl),
            // Info cards grid
            _buildInfoCards(context, user, firebaseUser, authProvider),
            const SizedBox(height: AppDimensions.md),
            // Security section
            Container(
              padding: const EdgeInsets.all(AppDimensions.lg),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerLowest,
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusXl),
                border:
                    Border.all(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bảo mật & Tài khoản',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.scaleFont(context, 18).clamp(16, 22),
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.md),
                  _buildSecurityButtons(context, authProvider),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.md),
            // Preferences
            Container(
              padding: const EdgeInsets.all(AppDimensions.lg),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerLowest,
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusXl),
                border:
                    Border.all(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tùy chỉnh ứng dụng',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.md),
                  _preferenceItem(
                    context,
                    Icons.notifications_outlined,
                    'Cấu hình thông báo',
                    trailing: Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.onSurfaceVariant),
                    onTap: () {
                      Navigator.of(context).pushNamed('/notification_settings');
                    },
                  ),
                  _preferenceItem(
                    context,
                    Icons.palette_outlined,
                    'Giao diện ứng dụng',
                    trailing: Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.onSurfaceVariant),
                    onTap: () {
                      Navigator.of(context).pushNamed('/app_theme');
                    },
                  ),
                  _preferenceItem(
                    context,
                    Icons.dark_mode_outlined,
                    'Chế độ tối (Dark Mode)',
                    trailing: Switch(
                      value: themeProvider.themeMode == ThemeMode.dark,
                      onChanged: (v) {
                        themeProvider.setThemeMode(
                          v ? ThemeMode.dark : ThemeMode.light,
                        );
                      },
                      activeTrackColor: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  _preferenceItem(
                    context,
                    Icons.language_outlined,
                    'Ngôn ngữ',
                    trailing: Text(
                      'Tiếng Việt',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Tính năng đang phát triển'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
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

  Widget _buildSecurityButtons(BuildContext context, AuthProvider authProvider) {
    final isSmall = MediaQuery.of(context).size.width < 420;
    if (isSmall) {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: _securityButton(context, Icons.lock_outlined, 'Đổi mật khẩu', 'Cập nhật mật khẩu mới', onTap: () => _handleChangePassword(context)),
          ),
          const SizedBox(height: AppDimensions.sm),
          SizedBox(
            width: double.infinity,
            child: _securityButton(context, Icons.verified_user_outlined, 'Xác thực 2 lớp', 'Bảo vệ tài khoản', onTap: () => _handleComingSoon(context)),
          ),
          const SizedBox(height: AppDimensions.sm),
          SizedBox(
            width: double.infinity,
            child: _securityButton(context, Icons.history_outlined, 'Lịch sử đăng nhập', 'Kiểm tra thiết bị', onTap: () => _handleComingSoon(context)),
          ),
          const SizedBox(height: AppDimensions.sm),
          SizedBox(
            width: double.infinity,
            child: _securityButton(context, Icons.logout, 'Đăng xuất', 'Kết thúc phiên làm việc', isDestructive: true, onTap: () => _handleLogout(context, authProvider)),
          ),
        ],
      );
    }
    return Wrap(
      spacing: AppDimensions.md,
      runSpacing: AppDimensions.md,
      children: [
        _securityButton(context, Icons.lock_outlined, 'Đổi mật khẩu', 'Cập nhật mật khẩu mới', onTap: () => _handleChangePassword(context)),
        _securityButton(context, Icons.verified_user_outlined, 'Xác thực 2 lớp', 'Bảo vệ tài khoản', onTap: () => _handleComingSoon(context)),
        _securityButton(context, Icons.history_outlined, 'Lịch sử đăng nhập', 'Kiểm tra thiết bị', onTap: () => _handleComingSoon(context)),
        _securityButton(context, Icons.logout, 'Đăng xuất', 'Kết thúc phiên làm việc', isDestructive: true, onTap: () => _handleLogout(context, authProvider)),
      ],
    );
  }

  void _handleComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tính năng đang phát triển'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _handleChangePassword(BuildContext context) async {
    final authProvider = context.read<AuthProvider>();
    final email = authProvider.user?.email;
    if (email == null || email.isEmpty) return;

    try {
      await firebase_auth.FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã gửi email đặt lại mật khẩu. Vui lòng kiểm tra hộp thư.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gửi email thất bại, vui lòng thử lại sau'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _handleLogout(BuildContext context, AuthProvider authProvider) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Đăng xuất'),
        content: const Text('Bạn có chắc muốn đăng xuất?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Đăng xuất', style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await authProvider.logout();
      if (!context.mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    }
  }

  Widget _buildProgressCard(BuildContext context) {
    final eventProvider = context.watch<EventProvider>();
    final total = eventProvider.events.length;
    final completed = eventProvider.events.where((e) => e.isCompleted).length;
    final rate = total > 0 ? completed / total : 0.0;
    final percent = (rate * 100).round();

    return Container(
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tiến độ tuần này',
            style: TextStyle(
              fontSize: ResponsiveHelper.scaleFont(context, 18).clamp(16, 22),
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: AppDimensions.xs),
          Text(
            'Bạn đã hoàn thành $percent% mục tiêu đã đề ra.',
            style: TextStyle(
              fontSize: ResponsiveHelper.scaleFont(context, 13).clamp(12, 15),
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: AppDimensions.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
            child: LinearProgressIndicator(
              value: rate,
              backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.surfaceContainerLowest),
            ),
          ),
          const SizedBox(height: AppDimensions.md),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.of(context).pushNamed('/analytics'),
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: const Text('Xem chi tiết'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCards(BuildContext context, User? user, firebase_auth.User? firebaseUser, AuthProvider authProvider) {
    final isSmall = MediaQuery.of(context).size.width < 420;
    if (isSmall) {
      return Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimensions.lg),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
              border: Border.all(color: Theme.of(context).colorScheme.surfaceVariant),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Thông tin cơ bản',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.scaleFont(context, 18).clamp(16, 22),
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    TextButton(
                      onPressed: () => _showEditDialog(context, authProvider),
                      child: Text(
                        'Chỉnh sửa',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.scaleFont(context, 11).clamp(10, 13),
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                _infoField(context, 'Họ và tên', user?.name ?? 'Alex'),
                Divider(height: 32, thickness: 1, color: Theme.of(context).colorScheme.outlineVariant),
                _infoField(context, 'Email', user?.email ?? 'adnostitanic0001@gmail.com'),
                Divider(height: 32, thickness: 1, color: Theme.of(context).colorScheme.outlineVariant),
                _infoField(context, 'Số điện thoại', '+84 123 456 789'),
                Divider(height: 32, thickness: 1, color: Theme.of(context).colorScheme.outlineVariant),
                _infoField(context, 'Ngày sinh', '01/01/2000'),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.md),
          _buildProgressCard(context),
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.all(AppDimensions.lg),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
              border: Border.all(color: Theme.of(context).colorScheme.surfaceVariant),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Thông tin cơ bản',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    TextButton(
                      onPressed: () => _showEditDialog(context, authProvider),
                      child: Text(
                        'Chỉnh sửa',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                _infoField(context, 'Email', user?.email ?? ''),
                _infoField(context, 'UID', firebaseUser?.uid ?? ''),
                _infoField(context, 'Số điện thoại', user?.phoneNumber ?? 'Chưa có'),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppDimensions.md),
        Expanded(child: _buildProgressCard(context)),
      ],
    );
  }

  Widget _infoField(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _securityButton(
      BuildContext context, IconData icon, String title, String subtitle,
      {bool isDestructive = false, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap != null ? () => onTap() : null,
      borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
      child: Container(
        width: ResponsiveHelper.scaleWidth(context, 180).clamp(140, 220),
        padding: const EdgeInsets.all(AppDimensions.md),
        decoration: BoxDecoration(
          border: Border.all(
            color: isDestructive
                ? Theme.of(context).colorScheme.error.withValues(alpha: 0.2)
                : Theme.of(context).colorScheme.outlineVariant,
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
          color: isDestructive
              ? Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.1)
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isDestructive
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.secondaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(icon,
                  color: isDestructive
                      ? Theme.of(context).colorScheme.onError
                      : Theme.of(context).colorScheme.onSecondaryContainer,
                  size: 20),
            ),
            const SizedBox(width: AppDimensions.sm + 4),
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
                      color: isDestructive
                          ? Theme.of(context).colorScheme.error
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    subtitle,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
                      color: isDestructive
                          ? Theme.of(context).colorScheme.error.withValues(alpha: 0.7)
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _preferenceItem(
      BuildContext context, IconData icon, String title, {Widget? trailing, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.md,
          vertical: AppDimensions.sm + 4,
        ),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(width: AppDimensions.md),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            ?trailing,
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => _EditProfileDialog(authProvider: authProvider),
    );
  }
}

class _EditProfileDialog extends StatefulWidget {
  final AuthProvider authProvider;
  const _EditProfileDialog({required this.authProvider});

  @override
  State<_EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<_EditProfileDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = widget.authProvider.user;
    _nameController = TextEditingController(text: user?.name ?? '');
    _phoneController = TextEditingController(text: user?.phoneNumber ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
      ),
      title: Text(
        'Chỉnh sửa thông tin',
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Họ và tên',
              labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
              ),
            ),
          ),
          SizedBox(height: AppDimensions.md),
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'Số điện thoại',
              labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Hủy',
            style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _handleSave,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Lưu'),
        ),
      ],
    );
  }

  Future<void> _handleSave() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    if (name.isEmpty) return;

    setState(() => _isLoading = true);
    await widget.authProvider.updateProfile(
      name: name,
      phoneNumber: phone.isNotEmpty ? phone : null,
    );
    if (!mounted) return;
    setState(() => _isLoading = false);
    Navigator.of(context).pop();
  }
}
