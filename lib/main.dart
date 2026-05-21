import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'shared/providers/theme_provider.dart';
import 'shared/providers/auth_provider.dart';
import 'shared/providers/event_provider.dart';
import 'shared/providers/category_provider.dart';
import 'features/splash/splash_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/register_screen.dart';
import 'features/home/home_screen.dart';
import 'features/settings/account_info_screen.dart';
import 'features/settings/notification_settings_screen.dart';
import 'features/settings/app_theme_screen.dart';
import 'features/calendar/add_event_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await initializeDateFormatting('vi_VN');

  // Initialize theme from SharedPreferences before app starts
  final themeProvider = ThemeProvider();
  await themeProvider.init();

  runApp(SchedulrApp(themeProvider: themeProvider));
}

class SchedulrApp extends StatelessWidget {
  final ThemeProvider themeProvider;
  const SchedulrApp({super.key, required this.themeProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, EventProvider>(
          create: (_) => EventProvider(),
          update: (_, authProvider, eventProvider) {
            final uid = authProvider.firebaseUser?.uid;
            eventProvider!.updateUser(uid);
            return eventProvider;
          },
        ),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
      ],
      child: Builder(
        builder: (context) {
          final themeProvider = context.watch<ThemeProvider>();
          return MaterialApp(
            title: 'Schedulr',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.lightTheme,
            darkTheme: themeProvider.darkTheme,
            themeMode: themeProvider.themeMode,
            initialRoute: '/',
            routes: {
              '/': (context) => const SplashScreen(),
              '/onboarding': (context) => const OnboardingScreen(),
              '/login': (context) => const LoginScreen(),
              '/dashboard': (context) => const HomeScreen(),
              '/home': (context) => const HomeScreen(),
              '/calendar': (context) => const HomeScreen(),
              '/tasks': (context) => const HomeScreen(),
              '/analytics': (context) => const HomeScreen(),
              '/settings': (context) => const HomeScreen(),
              '/account_info': (context) => const AccountInfoScreen(),
              '/notification_settings': (context) =>
                  const NotificationSettingsScreen(),
              '/app_theme': (context) => const AppThemeScreen(),
              '/add_event': (context) => const AddEventScreen(),
              '/register': (context) => const RegisterScreen(),
            },
          );
        },
      ),
    );
  }
}
