import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../shared/providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _isGoogleLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'Vui lòng nhập email và mật khẩu');
      return;
    }

    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    final authProvider = context.read<AuthProvider>();
    await authProvider.login(email, password);

    if (!mounted) return;

    setState(() {
      _isLoading = authProvider.isLoading;
      _errorMessage = authProvider.errorMessage;
    });

    if (authProvider.pendingTwoFactor) {
      Navigator.of(context).pushReplacementNamed('/otp_verification');
    } else if (authProvider.isLoggedIn) {
      Navigator.of(context).pushReplacementNamed('/dashboard');
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _errorMessage = null;
      _isGoogleLoading = true;
    });

    final authProvider = context.read<AuthProvider>();
    await authProvider.signInWithGoogle();

    if (!mounted) return;

    setState(() {
      _isGoogleLoading = false;
      _errorMessage = authProvider.errorMessage;
    });

    if (authProvider.pendingTwoFactor) {
      Navigator.of(context).pushReplacementNamed('/otp_verification');
    } else if (authProvider.isLoggedIn) {
      Navigator.of(context).pushReplacementNamed('/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.gutter),
            child: Container(
              constraints: BoxConstraints(maxWidth: AppDimensions.cardMaxWidth(context)),
              padding: const EdgeInsets.all(AppDimensions.xl),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerLowest,
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusXl),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.3),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 24,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Column(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF0099CC), Color(0xFF0055AA)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF0099CC).withValues(alpha: 0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.calendar_month,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.md),
                      Text(
                        AppStrings.loginTitle,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.sm),
                      Text(
                        AppStrings.loginSubtitle,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.lg),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _isGoogleLoading ? null : _handleGoogleSignIn,
                      icon: _isGoogleLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.g_mobiledata),
                      label: Text(_isGoogleLoading ? 'Đang xử lý...' : AppStrings.googleSignIn),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.onSurface,
                        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                        side: BorderSide.none,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.lg),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(color: Theme.of(context).colorScheme.outlineVariant),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.md),
                        child: Text(
                          AppStrings.or,
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.outline,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(color: Theme.of(context).colorScheme.outlineVariant),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.lg),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: AppStrings.emailLabel,
                      labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                      contentPadding: const EdgeInsets.all(16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.md),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: AppStrings.passwordLabel,
                      labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                      contentPadding: const EdgeInsets.all(16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                  ),
                  if (_errorMessage != null) ...[
                    const SizedBox(height: AppDimensions.sm),
                    Text(
                      _errorMessage!,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                  const SizedBox(height: AppDimensions.md + 4),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0099CC), Color(0xFF0055AA)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0099CC).withValues(alpha: 0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
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
                          : const Text(
                              AppStrings.login,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.sm),
                  TextButton(
                    onPressed: () => _showForgotPasswordDialog(),
                    child: Text(
                      AppStrings.forgotPassword,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.md),
                  Divider(color: Theme.of(context).colorScheme.outlineVariant),
                  const SizedBox(height: AppDimensions.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppStrings.noAccount,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pushNamed('/register'),
                        child: Text(
                          AppStrings.signUp,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showForgotPasswordDialog() {
    final resetEmailController = TextEditingController(text: _emailController.text);
    showDialog(
      context: context,
      builder: (ctx) {
        bool isSending = false;
        String? dialogError;
        bool isSent = false;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
              ),
              title: Text(
                'Quên mật khẩu',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isSent) ...[
                    Icon(
                      Icons.mark_email_read_outlined,
                      size: 48,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: AppDimensions.md),
                    Text(
                      'Đã gửi email đặt lại mật khẩu!',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppDimensions.sm),
                    Text(
                      'Nếu email này đã được đăng ký, bạn sẽ nhận được liên kết đặt lại mật khẩu trong hộp thư. Vui lòng kiểm tra cả mục Spam.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ] else ...[
                    Text(
                      'Nhập địa chỉ email của bạn để nhận liên kết đặt lại mật khẩu.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.md),
                    TextField(
                      controller: resetEmailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                    ),
                    if (dialogError != null) ...[
                      const SizedBox(height: AppDimensions.sm),
                      Text(
                        dialogError!,
                        style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.error),
                      ),
                    ],
                  ],
                ],
              ),
              actions: [
                if (isSent) ...[
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                      ),
                    ),
                    child: const Text('Đóng'),
                  ),
                ] else ...[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Hủy',
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: isSending
                        ? null
                        : () async {
                            final email = resetEmailController.text.trim();
                            if (email.isEmpty) {
                              setDialogState(() => dialogError = 'Vui lòng nhập email');
                              return;
                            }
                            setDialogState(() {
                              isSending = true;
                              dialogError = null;
                            });

                            final authProvider = ctx.read<AuthProvider>();
                            final error = await authProvider.resetPassword(email);

                            if (!context.mounted) return;

                            if (error == null) {
                              setDialogState(() {
                                isSending = false;
                                isSent = true;
                              });
                            } else {
                              setDialogState(() {
                                isSending = false;
                                dialogError = error;
                              });
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                      ),
                    ),
                    child: isSending
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Gửi email'),
                  ),
                ],
              ],
            );
          },
        );
      },
    );
  }
}
