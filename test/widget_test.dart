// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:nhom16_quanlylichtrinhcanhan/main.dart';
import 'package:nhom16_quanlylichtrinhcanhan/shared/providers/theme_provider.dart';
import 'package:nhom16_quanlylichtrinhcanhan/shared/providers/locale_provider.dart';
import 'package:nhom16_quanlylichtrinhcanhan/shared/providers/notification_provider.dart';

void main() {
  testWidgets('App launches smoke test', (WidgetTester tester) async {
    final themeProvider = ThemeProvider();
    final localeProvider = LocaleProvider();
    final notificationProvider = NotificationProvider();
    await tester.pumpWidget(SchedulrApp(
      themeProvider: themeProvider,
      localeProvider: localeProvider,
      notificationProvider: notificationProvider,
    ));
    expect(find.text('Schedulr'), findsOneWidget);
  });
}
