import 'package:flutter/material.dart';
import '../../shared/widgets/app_bottom_nav.dart';
import '../dashboard/dashboard_screen.dart';
import '../calendar/calendar_screen.dart';
import '../tasks/tasks_screen.dart';
import '../analytics/analytics_screen.dart';
import '../settings/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool _initialized = false;

  static const _routeToIndex = <String, int>{
    '/dashboard': 0,
    '/home': 0,
    '/calendar': 1,
    '/tasks': 2,
    '/analytics': 3,
    '/settings': 4,
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final routeName = ModalRoute.of(context)?.settings.name;
      if (routeName != null && _routeToIndex.containsKey(routeName)) {
        _currentIndex = _routeToIndex[routeName]!;
      }
      // Also support passing an explicit tab index as argument
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is int && args >= 0 && args < 5) {
        _currentIndex = args;
      }
    }
  }

  final List<Widget> _screens = [
    DashboardScreen(),
    CalendarScreen(),
    TasksScreen(),
    AnalyticsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index != _currentIndex) {
            setState(() => _currentIndex = index);
          }
        },
      ),
    );
  }
}
