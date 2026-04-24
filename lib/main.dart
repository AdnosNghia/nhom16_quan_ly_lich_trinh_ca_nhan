import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/app_theme.dart';
import 'features/splash/presentation/splash_screen.dart';
import 'features/onboarding/presentation/onboarding_screen.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/dashboard/presentation/dashboard_screen.dart';
import 'features/calendar/presentation/calendar_screen.dart';
import 'features/tasks/presentation/tasks_screen.dart';
import 'features/analytics/presentation/analytics_screen.dart';
import 'features/settings/presentation/settings_screen.dart';
import 'features/settings/presentation/account_info_screen.dart';
import 'features/settings/presentation/notification_settings_screen.dart';
import 'features/settings/presentation/app_theme_screen.dart';
import 'features/calendar/presentation/add_event_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const SchedulrApp());
}

class SchedulrApp extends StatelessWidget {
  const SchedulrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Schedulr',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/calendar': (context) => const CalendarScreen(),
        '/tasks': (context) => const TasksScreen(),
        '/analytics': (context) => const AnalyticsScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/account_info': (context) => const AccountInfoScreen(),
        '/notification_settings': (context) =>
            const NotificationSettingsScreen(),
        '/app_theme': (context) => const AppThemeScreen(),
        '/add_event': (context) => const AddEventScreen(),
      },
    );
  }
}
