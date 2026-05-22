import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../core/constants/app_dimensions.dart';
import '../../shared/providers/auth_provider.dart';
import '../../domain/entities/login_history.dart';

class LoginHistoryScreen extends StatefulWidget {
  const LoginHistoryScreen({super.key});

  @override
  State<LoginHistoryScreen> createState() => _LoginHistoryScreenState();
}

class _LoginHistoryScreenState extends State<LoginHistoryScreen> {
  List<LoginHistory> _history = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final authProvider = context.read<AuthProvider>();
    final history = await authProvider.getLoginHistory();
    if (!mounted) return;
    setState(() {
      _history = history;
      _isLoading = false;
    });
  }

  Future<void> _handleClearHistory() async {
    final l = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        ),
        title: Text(
          l.clearHistory,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.error,
          ),
        ),
        content: Text(
          l.clearHistoryConfirm,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              l.cancel,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              ),
            ),
            child: Text(l.delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await context.read<AuthProvider>().clearLoginHistory();
      if (!mounted) return;
      setState(() {
        _history = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: cs.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          l.loginHistoryTitle,
          style: TextStyle(
            color: cs.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          if (_history.isNotEmpty)
            IconButton(
              icon: Icon(Icons.delete_outline, color: cs.error),
              onPressed: _handleClearHistory,
              tooltip: l.clearHistory,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _history.isEmpty
              ? _buildEmptyState(cs, l)
              : _buildHistoryList(cs, l),
    );
  }

  Widget _buildEmptyState(ColorScheme cs, AppLocalizations l) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimensions.xl),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHigh,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.history,
              size: 48,
              color: cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppDimensions.lg),
          Text(
            l.noLoginHistory,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: cs.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList(ColorScheme cs, AppLocalizations l) {
    // Separate current session (first item = most recent) from previous
    final current = _history.isNotEmpty ? _history.first : null;
    final previous = _history.length > 1 ? _history.sublist(1) : <LoginHistory>[];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.marginMobile),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current session header card
          if (current != null) ...[
            _buildSectionTitle(cs, l.currentSession),
            const SizedBox(height: AppDimensions.sm),
            _buildCurrentSessionCard(cs, l, current),
            const SizedBox(height: AppDimensions.lg),
          ],

          // Previous sessions
          if (previous.isNotEmpty) ...[
            _buildSectionTitle(cs, l.previousSessions),
            const SizedBox(height: AppDimensions.sm),
            ...previous.map((item) => _buildHistoryItem(cs, l, item)),
          ],

          const SizedBox(height: AppDimensions.xxl),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(ColorScheme cs, String title) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: cs.primary,
        letterSpacing: 1,
      ),
    );
  }

  Widget _buildCurrentSessionCard(ColorScheme cs, AppLocalizations l, LoginHistory item) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            cs.primaryContainer,
            cs.primaryContainer.withValues(alpha: 0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: cs.onPrimaryContainer.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            child: Icon(
              _getDeviceIcon(item.deviceType),
              color: cs.onPrimaryContainer,
              size: 24,
            ),
          ),
          const SizedBox(width: AppDimensions.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        item.deviceName,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: cs.onPrimaryContainer,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.sm),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.sm,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: cs.primary,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                      ),
                      child: Text(
                        l.currentSession,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: cs.onPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.platform,
                  style: TextStyle(
                    fontSize: 12,
                    color: cs.onPrimaryContainer.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _getLoginMethodText(l, item.loginMethod),
                  style: TextStyle(
                    fontSize: 12,
                    color: cs.onPrimaryContainer.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(ColorScheme cs, AppLocalizations l, LoginHistory item) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.sm),
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: cs.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            child: Icon(
              _getDeviceIcon(item.deviceType),
              color: cs.onSurfaceVariant,
              size: 22,
            ),
          ),
          const SizedBox(width: AppDimensions.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.deviceName,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${item.platform} • ${_getLoginMethodText(l, item.loginMethod)}',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Text(
            _getRelativeTime(l, item.loginTime),
            style: TextStyle(
              fontSize: 11,
              color: cs.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getDeviceIcon(String deviceType) {
    switch (deviceType) {
      case 'mobile':
        return Icons.phone_android;
      case 'tablet':
        return Icons.tablet_android;
      case 'desktop':
        return Icons.computer;
      case 'web':
        return Icons.language;
      default:
        return Icons.devices;
    }
  }

  String _getLoginMethodText(AppLocalizations l, String method) {
    switch (method) {
      case 'google':
        return l.loginViaGoogle;
      case 'email':
      default:
        return l.loginViaEmail;
    }
  }

  String _getRelativeTime(AppLocalizations l, DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) return l.justNow;
    if (diff.inMinutes < 60) return l.minutesAgo(diff.inMinutes);
    if (diff.inHours < 24) return l.hoursAgo(diff.inHours);
    if (diff.inDays < 30) return l.daysAgo(diff.inDays);

    // For older dates, show formatted date
    return '${time.day}/${time.month}/${time.year}';
  }
}
