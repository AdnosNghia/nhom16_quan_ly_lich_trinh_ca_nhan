import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../core/helpers/responsive_helper.dart';
import '../../shared/providers/auth_provider.dart';
import '../../shared/providers/category_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (!mounted) return;
    try {
      await Future.wait([
        context.read<AuthProvider>().checkLoginStatus(),
        context.read<CategoryProvider>().loadCategories(),
      ]).timeout(const Duration(seconds: 10));
    } catch (_) {
      // Timeout or error — proceed anyway
    }

    if (!mounted) return;
    final authProvider = context.read<AuthProvider>();
    if (authProvider.isLoggedIn) {
      Navigator.of(context).pushReplacementNamed('/dashboard');
    } else {
      Navigator.of(context).pushReplacementNamed('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            colors: [
              Color(0xFF0099CC),
              Color(0xFF0055AA),
            ],
            radius: 1.5,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Spacer(),
              Column(
                children: [
                  Container(
                    width: ResponsiveHelper.scaleWidth(context, 120).clamp(80, 180),
                    height: ResponsiveHelper.scaleWidth(context, 120).clamp(80, 180),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white24,
                    ),
                    child: Icon(
                      Icons.calendar_today,
                      size: ResponsiveHelper.scaleWidth(context, 60).clamp(40, 90),
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.lg),
                  Text(
                    AppStrings.appName,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.scaleFont(context, 28).clamp(22, 40),
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 6,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: AppDimensions.xl),
                child: Column(
                  children: [
                    SizedBox(
                      width: ResponsiveHelper.scaleWidth(context, 48).clamp(32, 80),
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusFull),
                        child: const LinearProgressIndicator(
                          backgroundColor: Colors.white24,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          minHeight: 4,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.md),
                    Text(
                      AppStrings.splashSubtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white60,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
