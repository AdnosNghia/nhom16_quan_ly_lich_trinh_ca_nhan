import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../shared/providers/theme_provider.dart';
import '../../shared/widgets/app_header.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/l10n.dart';
import '../../shared/providers/locale_provider.dart';
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
            const AppHeader(),
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
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 36,
                            backgroundColor: cs.primaryContainer,
                            child: Icon(Icons.person, size: 36, color: cs.primary),
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
                              Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                child: const Text(
                                  'Thành viên Pro',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
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
                    ]),
                    const SizedBox(height: AppDimensions.md),
                    _settingsGroup(cs, 'Ứng dụng', [
                      _settingsItem(cs, Icons.notifications_active_outlined, AppStrings.notificationConfig, () => Navigator.of(context).pushNamed('/notification_settings')),
                      _settingsItem(cs, Icons.palette_outlined, AppStrings.appTheme, () => Navigator.of(context).pushNamed('/app_theme')),
                      _settingsItem(cs, Icons.language_outlined, 'Ngôn ngữ', () => _showLanguagePicker(context)),
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

  void _showLanguagePicker(BuildContext context) {
    final localeProvider = context.read<LocaleProvider>();
    final l = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusXl)),
      ),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppDimensions.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: AppDimensions.md),
                Text(
                  l.selectLanguage,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: AppDimensions.md),
                ...L10n.supportedLocales.map((locale) {
                  final isSelected = localeProvider.locale.languageCode == locale.languageCode;
                  return ListTile(
                    leading: Text(
                      L10n.getFlag(locale.languageCode),
                      style: const TextStyle(fontSize: 28),
                    ),
                    title: Text(
                      L10n.getLanguageName(locale.languageCode),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary)
                        : null,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                    ),
                    onTap: () {
                      localeProvider.setLocale(locale);
                      Navigator.of(ctx).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l.languageChanged),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  );
                }),
                const SizedBox(height: AppDimensions.sm),
              ],
            ),
          ),
        );
      },
    );
  }
}
