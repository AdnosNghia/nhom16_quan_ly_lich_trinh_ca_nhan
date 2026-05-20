import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../shared/providers/auth_provider.dart';
import '../../shared/widgets/app_bottom_nav.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Future<void> _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Đăng xuất'),
        content: const Text('Bạn có chắc muốn đăng xuất?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Hủy')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Đăng xuất', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await context.read<AuthProvider>().logout();
      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    }
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
                      AppStrings.settings,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.xs),
                    const Text(
                      'Quản lý tài khoản và tùy chỉnh trải nghiệm của bạn.',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.lg),
                    Container(
                      padding: const EdgeInsets.all(AppDimensions.lg),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
                        border: Border.all(color: AppColors.surfaceVariant.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 36,
                                backgroundColor: AppColors.primaryFixed,
                                child: const Icon(Icons.person, size: 36, color: AppColors.primary),
                              ),
                              Positioned(
                                bottom: 0, right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(color: AppColors.primaryContainer, shape: BoxShape.circle),
                                  child: const Icon(Icons.edit, size: 14, color: AppColors.onPrimaryContainer),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: AppDimensions.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  context.watch<AuthProvider>().user?.name ?? 'Nguyễn Văn A',
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.onSurface),
                                ),
                                Text(
                                  context.watch<AuthProvider>().user?.email ?? 'vanna.dev@email.com',
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 14, color: AppColors.onSurfaceVariant),
                                ),
                              const SizedBox(height: AppDimensions.xs),
                              const Chip(
                                label: Text('Thành viên Pro', style: TextStyle(fontSize: 12, color: AppColors.onTertiaryFixed)),
                                backgroundColor: AppColors.tertiaryFixed,
                                side: BorderSide.none,
                                padding: EdgeInsets.zero,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity.compact,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppDimensions.lg),
                  _settingsGroup('Tài khoản', [
                      _settingsItem(Icons.person_outline, AppStrings.accountInfo, () => Navigator.of(context).pushNamed('/account_info')),
                      _settingsItem(Icons.shield_outlined, AppStrings.security, () {}),
                    ]),
                    const SizedBox(height: AppDimensions.md),
                    _settingsGroup('Ứng dụng', [
                      _settingsItem(Icons.notifications_active_outlined, AppStrings.notificationConfig, () => Navigator.of(context).pushNamed('/notification_settings')),
                      _settingsItem(Icons.palette_outlined, AppStrings.appTheme, () => Navigator.of(context).pushNamed('/app_theme')),
                    ]),
                    const SizedBox(height: AppDimensions.lg),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _handleLogout,
                        icon: const Icon(Icons.logout),
                        label: const Text(AppStrings.logout),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.error,
                          side: const BorderSide(color: AppColors.errorContainer),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusXl)),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.lg),
                    const Center(
                      child: Column(
                        children: [
                          Text('Schedulr Phiên bản 2.4.0 (Build 108)', style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
                          SizedBox(height: AppDimensions.xs),
                          Text('© 2024 Schedulr Inc.', style: TextStyle(fontSize: 12, color: AppColors.outlineVariant)),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDimensions.xxl),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 4,
        onTap: (index) {
          switch (index) {
            case 0: Navigator.of(context).pushReplacementNamed('/dashboard'); break;
            case 1: Navigator.of(context).pushReplacementNamed('/calendar'); break;
            case 2: Navigator.of(context).pushReplacementNamed('/tasks'); break;
            case 3: Navigator.of(context).pushReplacementNamed('/analytics'); break;
            case 4: break;
          }
        },
      ),
    );
  }

  Widget _settingsGroup(String title, List<Widget> items) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        border: Border.all(color: AppColors.surfaceVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(AppDimensions.md, AppDimensions.sm + 4, AppDimensions.md, AppDimensions.sm),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusXl)),
            ),
            child: Text(title.toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary, letterSpacing: 1)),
          ),
          ...items,
        ],
      ),
    );
  }

  Widget _settingsItem(IconData icon, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.md),
        child: Row(
          children: [
            Icon(icon, color: AppColors.onSurfaceVariant, size: 24),
            const SizedBox(width: AppDimensions.md),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.onSurface))),
            const Icon(Icons.chevron_right, color: AppColors.outlineVariant),
          ],
        ),
      ),
    );
  }
}
