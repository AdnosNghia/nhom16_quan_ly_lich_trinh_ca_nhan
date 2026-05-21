import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../shared/providers/auth_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Future<void> _handleLogout() async {
    final cs = Theme.of(context).colorScheme;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Đăng xuất'),
        content: const Text('Bạn có chắc muốn đăng xuất?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Hủy')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Đăng xuất', style: TextStyle(color: cs.error)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      if (!mounted) return;
      await context.read<AuthProvider>().logout();
      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surface,
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
                    backgroundColor: cs.surfaceContainerHigh,
                    child: Icon(Icons.person_outline, color: cs.onSurface),
                  ),
                  const SizedBox(width: AppDimensions.sm + 4),
                  Text(
                    'Schedulr',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: cs.primary,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    color: cs.primary,
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
                    Text(
                      AppStrings.settings,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.xs),
                    Text(
                      'Quản lý tài khoản và tùy chỉnh trải nghiệm của bạn.',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.lg),
                    Container(
                      padding: const EdgeInsets.all(AppDimensions.lg),
                      decoration: BoxDecoration(
                        color: cs.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
                        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 36,
                                backgroundColor: cs.primaryContainer,
                                child: Icon(Icons.person, size: 36, color: cs.primary),
                              ),
                              Positioned(
                                bottom: 0, right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(color: cs.primaryContainer, shape: BoxShape.circle),
                                  child: Icon(Icons.edit, size: 14, color: cs.onPrimaryContainer),
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
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: cs.onSurface),
                                ),
                                Text(
                                  context.watch<AuthProvider>().user?.email ?? 'vanna.dev@email.com',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 14, color: cs.onSurfaceVariant),
                                ),
                              const SizedBox(height: AppDimensions.xs),
                              Chip(
                                label: Text('Thành viên Pro', style: TextStyle(fontSize: 12, color: cs.onTertiaryContainer)),
                                backgroundColor: cs.tertiaryContainer,
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
                  _settingsGroup(cs, 'Tài khoản', [
                      _settingsItem(cs, Icons.person_outline, AppStrings.accountInfo, () => Navigator.of(context).pushNamed('/account_info')),
                      _settingsItem(cs, Icons.shield_outlined, AppStrings.security, () {}),
                    ]),
                    const SizedBox(height: AppDimensions.md),
                    _settingsGroup(cs, 'Ứng dụng', [
                      _settingsItem(cs, Icons.notifications_active_outlined, AppStrings.notificationConfig, () => Navigator.of(context).pushNamed('/notification_settings')),
                      _settingsItem(cs, Icons.palette_outlined, AppStrings.appTheme, () => Navigator.of(context).pushNamed('/app_theme')),
                    ]),
                    const SizedBox(height: AppDimensions.lg),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _handleLogout,
                        icon: const Icon(Icons.logout),
                        label: const Text(AppStrings.logout),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: cs.error,
                          side: BorderSide(color: cs.errorContainer),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusXl)),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.lg),
                    Center(
                      child: Column(
                        children: [
                          Text('Schedulr Phiên bản 2.4.0 (Build 108)', style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant)),
                          const SizedBox(height: AppDimensions.xs),
                          Text('© 2024 Schedulr Inc.', style: TextStyle(fontSize: 12, color: cs.outlineVariant)),
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
    );
  }

  Widget _settingsGroup(ColorScheme cs, String title, List<Widget> items) {
    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(AppDimensions.md, AppDimensions.sm + 4, AppDimensions.md, AppDimensions.sm),
            decoration: BoxDecoration(
              color: cs.surfaceContainerLow,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusXl)),
            ),
            child: Text(title.toUpperCase(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: cs.primary, letterSpacing: 1)),
          ),
          ...items,
        ],
      ),
    );
  }

  Widget _settingsItem(ColorScheme cs, IconData icon, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.md),
        child: Row(
          children: [
            Icon(icon, color: cs.onSurfaceVariant, size: 24),
            const SizedBox(width: AppDimensions.md),
            Expanded(child: Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: cs.onSurface))),
            Icon(Icons.chevron_right, color: cs.outlineVariant),
          ],
        ),
      ),
    );
  }
}
