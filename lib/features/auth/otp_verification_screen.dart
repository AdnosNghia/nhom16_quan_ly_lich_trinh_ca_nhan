import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_dimensions.dart';
import '../../shared/providers/auth_provider.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  bool _isVerifying = false;
  String? _errorMessage;
  int _remainingSeconds = 300; // 5 phut
  Timer? _timer;
  bool _canResend = false;
  int _resendCooldown = 0;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer?.cancel();
    _remainingSeconds = 300;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          timer.cancel();
        }
        if (_resendCooldown > 0) {
          _resendCooldown--;
          if (_resendCooldown == 0) _canResend = true;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _otpCode => _controllers.map((c) => c.text).join();

  String get _formattedTime {
    final m = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  Future<void> _handleVerify() async {
    final code = _otpCode;
    if (code.length != 6) {
      setState(() => _errorMessage = 'Vui lòng nhập đủ 6 số');
      return;
    }
    if (_remainingSeconds <= 0) {
      setState(() => _errorMessage = 'Mã OTP đã hết hạn, vui lòng gửi lại');
      return;
    }

    setState(() {
      _isVerifying = true;
      _errorMessage = null;
    });

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.verifyOtp(code);

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pushNamedAndRemoveUntil('/dashboard', (route) => false);
    } else {
      setState(() {
        _isVerifying = false;
        _errorMessage = 'Mã OTP không đúng hoặc đã hết hạn';
        // Xóa input
        for (final c in _controllers) {
          c.clear();
        }
        _focusNodes[0].requestFocus();
      });
    }
  }

  Future<void> _handleResend() async {
    if (!_canResend && _resendCooldown > 0) return;

    final authProvider = context.read<AuthProvider>();
    await authProvider.resendOtp();

    if (!mounted) return;



    setState(() {
      _canResend = false;
      _resendCooldown = 30;
      _remainingSeconds = 300;
      _errorMessage = null;
      for (final c in _controllers) {
        c.clear();
      }
    });

    _focusNodes[0].requestFocus();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã gửi lại mã OTP mới'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _handleCancel() async {
    final authProvider = context.read<AuthProvider>();
    await authProvider.cancelTwoFactor();
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final email = authProvider.user?.email ?? '';
    final maskedEmail = _maskEmail(email);

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
                borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
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
                  // Icon
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.verified_user_outlined,
                      size: 32,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.md),

                  // Title
                  Text(
                    'Xác thực 2 lớp',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.sm),

                  // Description
                  Text(
                    'Nhập mã xác thực 6 số đã được gửi đến',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    maskedEmail,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.lg),

                  // OTP Input fields
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(6, (index) {
                      return Container(
                        width: 44,
                        height: 52,
                        margin: EdgeInsets.only(right: index < 5 ? 8.0 : 0),
                        child: TextField(
                          controller: _controllers[index],
                          focusNode: _focusNodes[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          decoration: InputDecoration(
                            counterText: '',
                            contentPadding: const EdgeInsets.symmetric(vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.outlineVariant,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.surfaceContainerLowest,
                          ),
                          onChanged: (value) {
                            if (value.isNotEmpty && index < 5) {
                              _focusNodes[index + 1].requestFocus();
                            }
                            if (value.isEmpty && index > 0) {
                              _focusNodes[index - 1].requestFocus();
                            }
                            // Auto-verify khi nhập đủ 6 số
                            if (_otpCode.length == 6) {
                              _handleVerify();
                            }
                          },
                        ),
                      );
                    }),
                  )),
                  const SizedBox(height: AppDimensions.md),

                  // Timer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        size: 16,
                        color: _remainingSeconds <= 60
                            ? Theme.of(context).colorScheme.error
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Mã hết hạn sau $_formattedTime',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: _remainingSeconds <= 60
                              ? Theme.of(context).colorScheme.error
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),

                  // Error message
                  if (_errorMessage != null) ...[
                    const SizedBox(height: AppDimensions.sm),
                    Text(
                      _errorMessage!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],

                  const SizedBox(height: AppDimensions.lg),

                  // Verify button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isVerifying ? null : _handleVerify,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                        ),
                        elevation: 4,
                        shadowColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                      ),
                      child: _isVerifying
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Xác thực',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.md),

                  // Resend
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        'Không nhận được mã?',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      TextButton(
                        onPressed: (_canResend || _resendCooldown == 0) ? _handleResend : null,
                        child: Text(
                          _resendCooldown > 0
                              ? 'Gửi lại (${_resendCooldown}s)'
                              : 'Gửi lại mã',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: (_canResend || _resendCooldown == 0)
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppDimensions.sm),
                  Divider(color: Theme.of(context).colorScheme.outlineVariant),
                  const SizedBox(height: AppDimensions.sm),

                  // Cancel
                  TextButton.icon(
                    onPressed: _handleCancel,
                    icon: Icon(
                      Icons.arrow_back,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    label: Text(
                      'Quay lại đăng nhập',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _maskEmail(String email) {
    if (!email.contains('@')) return email;
    final parts = email.split('@');
    final name = parts[0];
    if (name.length <= 3) return email;
    return '${name.substring(0, 3)}${'*' * (name.length - 3)}@${parts[1]}';
  }
}
