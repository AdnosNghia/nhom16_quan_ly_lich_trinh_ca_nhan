import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'l10n/l10n.dart';
import 'firebase_options.dart';
import 'shared/providers/theme_provider.dart';
import 'shared/providers/auth_provider.dart';
import 'shared/providers/event_provider.dart';
import 'shared/providers/category_provider.dart';
import 'shared/providers/locale_provider.dart';
import 'shared/providers/notification_provider.dart';
import 'core/services/notification_service.dart';
import 'features/splash/splash_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/register_screen.dart';
import 'features/auth/otp_verification_screen.dart';
import 'features/home/home_screen.dart';
import 'features/settings/account_info_screen.dart';
import 'features/settings/notification_settings_screen.dart';
import 'features/settings/app_theme_screen.dart';
import 'features/settings/login_history_screen.dart';
import 'features/calendar/add_event_screen.dart';
import 'features/notifications/notification_history_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await initializeDateFormatting('vi_VN');

  // Initialize theme and locale from SharedPreferences before app starts
  final themeProvider = ThemeProvider();
  await themeProvider.init();

  final localeProvider = LocaleProvider();
  await localeProvider.init();

  // Initialize notification service and provider
  final notificationProvider = NotificationProvider();
  await notificationProvider.init();
  await NotificationService().init();

  runApp(SchedulrApp(
    themeProvider: themeProvider,
    localeProvider: localeProvider,
    notificationProvider: notificationProvider,
  ));
}

class SchedulrApp extends StatelessWidget {
  final ThemeProvider themeProvider;
  final LocaleProvider localeProvider;
  final NotificationProvider notificationProvider;
  const SchedulrApp({
    super.key,
    required this.themeProvider,
    required this.localeProvider,
    required this.notificationProvider,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider.value(value: localeProvider),
        ChangeNotifierProvider.value(value: notificationProvider),
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
          final localeProvider = context.watch<LocaleProvider>();
          return MaterialApp(
            title: 'Schedulr',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.lightTheme,
            darkTheme: themeProvider.darkTheme,
            themeMode: themeProvider.themeMode,
            locale: localeProvider.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: L10n.supportedLocales,
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
              '/otp_verification': (context) => const OtpVerificationScreen(),
              '/login_history': (context) => const LoginHistoryScreen(),
              '/notification_history': (context) => const NotificationHistoryScreen(),
            },
          );
        },
      ),
    );
  }
}
