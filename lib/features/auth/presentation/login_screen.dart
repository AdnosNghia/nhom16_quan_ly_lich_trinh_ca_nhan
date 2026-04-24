import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.gutter),
            child: Container(
              width: 400,
              padding: const EdgeInsets.all(AppDimensions.xl),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusXl),
                border: Border.all(
                  color: AppColors.outlineVariant.withValues(alpha: 0.3),
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
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(
                              AppDimensions.radiusXl),
                        ),
                        child: const Icon(
                          Icons.calendar_today,
                          color: AppColors.onPrimary,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.md),
                      Text(
                        AppStrings.loginTitle,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.sm),
                      Text(
                        AppStrings.loginSubtitle,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.lg),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.g_mobiledata),
                      label: const Text(AppStrings.googleSignIn),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.onSurface,
                        side: BorderSide(
                          color: AppColors.outlineVariant,
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              AppDimensions.radiusMd),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.lg),
                  Row(
                    children: [
                      const Expanded(
                        child: Divider(color: AppColors.outlineVariant),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.md),
                        child: Text(
                          AppStrings.or,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.outline,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Divider(color: AppColors.outlineVariant),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.lg),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: AppStrings.emailLabel,
                      labelStyle: const TextStyle(
                          color: AppColors.onSurfaceVariant),
                      border: const UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.outlineVariant),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.primary),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.md),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: AppStrings.passwordLabel,
                      labelStyle: const TextStyle(
                          color: AppColors.onSurfaceVariant),
                      border: const UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.outlineVariant),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.primary),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppColors.outline,
                        ),
                        onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.md + 4),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacementNamed('/dashboard');
                      },
                      style: ElevatedButton.styleFrom(
                        padding:
                            const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              AppDimensions.radiusMd),
                        ),
                        elevation: 4,
                        shadowColor:
                            AppColors.primary.withValues(alpha: 0.3),
                      ),
                      child: const Text(AppStrings.login),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.sm),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      AppStrings.forgotPassword,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.md),
                  const Divider(color: AppColors.outlineVariant),
                  const SizedBox(height: AppDimensions.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        AppStrings.noAccount,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          AppStrings.signUp,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.secondary,
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
}
