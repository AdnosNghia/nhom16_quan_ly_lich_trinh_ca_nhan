import 'package:flutter/material.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/onboarding');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            colors: [
              Color(0xFF7B74FF),
              Color(0xFF4D41DF),
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
                    width: 120,
                    height: 120,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white24,
                    ),
                    child: const Icon(
                      Icons.calendar_today,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.lg),
                  Text(
                    AppStrings.appName,
                    style: const TextStyle(
                      fontSize: 28,
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
                      width: 48,
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
