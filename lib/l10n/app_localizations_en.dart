// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Schedulr';

  @override
  String get splashSubtitle => 'Initializing your workspace...';

  @override
  String get skip => 'Skip';

  @override
  String get next => 'Next';

  @override
  String get getStarted => 'Get Started';

  @override
  String get loginTitle => 'Schedulr';

  @override
  String get loginSubtitle => 'Plan every day, simplify your life';

  @override
  String get googleSignIn => 'Continue with Google';

  @override
  String get or => 'OR';

  @override
  String get emailLabel => 'Email Address';

  @override
  String get passwordLabel => 'Password';

  @override
  String get login => 'Sign In';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get noAccount => 'Don\'t have an account?';

  @override
  String get signUp => 'Sign Up';

  @override
  String get confirmPasswordLabel => 'Confirm Password';

  @override
  String get fullNameLabel => 'Full Name';

  @override
  String get hasAccount => 'Already have an account?';

  @override
  String get processing => 'Processing...';

  @override
  String get greetingMorning => 'Good morning,';

  @override
  String get greetingAfternoon => 'Good afternoon,';

  @override
  String get greetingEvening => 'Good evening,';

  @override
  String get progressToday => 'Today\'s Progress';

  @override
  String get progressDesc => 'You\'re doing great! Almost there.';

  @override
  String get priorityTasks => 'Priority Tasks';

  @override
  String get upcomingEvents => 'Upcoming Events';

  @override
  String get viewAll => 'View All';

  @override
  String get viewCalendar => 'View Calendar';

  @override
  String tasksOf(int completed, int total) {
    return '$completed of $total tasks';
  }

  @override
  String get navHome => 'Home';

  @override
  String get navCalendar => 'Calendar';

  @override
  String get navTasks => 'Tasks';

  @override
  String get navAnalytics => 'Analytics';

  @override
  String get navSettings => 'Settings';

  @override
  String get monthView => 'Month';

  @override
  String get weekView => 'Week';

  @override
  String get dayView => 'Day';

  @override
  String get eisenhowerTitle => 'Eisenhower Matrix';

  @override
  String get eisenhowerDesc =>
      'Prioritize tasks based on urgency and importance.';

  @override
  String get doNow => 'Do Now';

  @override
  String get schedule => 'Schedule';

  @override
  String get delegateTask => 'Delegate';

  @override
  String get eliminate => 'Eliminate';

  @override
  String get weeklyOverview => 'Weekly Overview';

  @override
  String get productivityScore => 'Productivity Score';

  @override
  String get tasksCompleted => 'Tasks Completed';

  @override
  String get timeDistribution => 'Time Distribution';

  @override
  String get focusStats => 'Focus Stats';

  @override
  String get activity30Days => '30-Day Activity';

  @override
  String get smartSuggestions => 'Smart Suggestions';

  @override
  String get settings => 'Settings';

  @override
  String get settingsSubtitle =>
      'Manage your account and customize your experience.';

  @override
  String get accountInfo => 'Account Information';

  @override
  String get security => 'Security & Privacy';

  @override
  String get notificationConfig => 'Notification Settings';

  @override
  String get appTheme => 'App Theme';

  @override
  String get logout => 'Sign Out';

  @override
  String get logoutConfirm => 'Are you sure you want to sign out?';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get confirm => 'Confirm';

  @override
  String get proBadge => 'Pro Member';

  @override
  String get accountGroup => 'Account';

  @override
  String get appGroup => 'Application';

  @override
  String get versionInfo => 'Schedulr Version 2.4.0 (Build 108)';

  @override
  String get copyright => '© 2024 Schedulr Inc.';

  @override
  String get addEvent => 'Add Event';

  @override
  String get eventName => 'Your event name...';

  @override
  String get start => 'Start';

  @override
  String get end => 'End';

  @override
  String get allDay => 'All Day';

  @override
  String get category => 'Category';

  @override
  String get reminder => 'Reminder';

  @override
  String get subTasks => 'Subtasks';

  @override
  String get addSubTask => 'Add task';

  @override
  String get saveEvent => 'Save Event';

  @override
  String get profileTitle => 'Personal Profile';

  @override
  String get personalInfo => 'Basic Information';

  @override
  String get securityAccount => 'Security & Account';

  @override
  String get appCustomization => 'App Customization';

  @override
  String get changePassword => 'Change Password';

  @override
  String get changePasswordSub => 'Update your password';

  @override
  String get twoFactorAuth => 'Two-Factor Auth';

  @override
  String get twoFactorProtect => 'Protect your account';

  @override
  String get twoFactorEnabled => 'Enabled';

  @override
  String get twoFactorDisabled => 'Disabled';

  @override
  String get loginHistory => 'Login History';

  @override
  String get loginHistorySub => 'Check devices';

  @override
  String get logoutSub => 'End your session';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get language => 'Language';

  @override
  String get vietnamese => 'Vietnamese';

  @override
  String get english => 'English';

  @override
  String get featureComingSoon => 'Feature under development';

  @override
  String get notUpdated => 'Not updated';

  @override
  String get user => 'User';

  @override
  String get fullName => 'Full Name';

  @override
  String get email => 'Email';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get uid => 'UID';

  @override
  String get weekProgress => 'This Week\'s Progress';

  @override
  String weekProgressDesc(int percent) {
    return 'You\'ve completed $percent% of your goals.';
  }

  @override
  String get viewDetails => 'View Details';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get passwordResetSent =>
      'Password reset email sent. Please check your inbox.';

  @override
  String get passwordResetFailed =>
      'Failed to send email, please try again later';

  @override
  String get twoFactorTitle => 'Two-Factor Authentication';

  @override
  String get twoFactorEnableMsg =>
      'When enabled, you\'ll need to enter a 6-digit OTP code each time you sign in to verify your identity.';

  @override
  String get twoFactorDisableMsg =>
      'Do you want to disable two-factor authentication? Your account will be less secure.';

  @override
  String get twoFactorEnabledSuccess =>
      'Two-factor authentication enabled successfully';

  @override
  String get twoFactorDisabledSuccess => 'Two-factor authentication disabled';

  @override
  String get enableAuth => 'Enable';

  @override
  String get disable => 'Disable';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get languageChanged => 'Language changed successfully';

  @override
  String get notificationTitle => 'Notifications';

  @override
  String get managePreferences => 'Manage Preferences';

  @override
  String get managePreferencesSub =>
      'Customize how you receive notifications from Schedulr.';

  @override
  String get generalSettings => 'General Settings';

  @override
  String get pushNotifications => 'Push Notifications';

  @override
  String get pushNotificationsSub =>
      'Receive instant notifications on lock screen';

  @override
  String get sound => 'Sound';

  @override
  String get soundSub => 'Play sound for new notifications';

  @override
  String get eventsCalendar => 'Events & Calendar';

  @override
  String get eventReminder => 'Event Reminder';

  @override
  String get eventReminderSub => 'Notify 15 minutes before start';

  @override
  String get weeklyReport => 'Weekly Report';

  @override
  String get weeklyReportSub => 'Productivity summary on Monday morning';

  @override
  String get quietHours => 'Quiet Hours';

  @override
  String get quietHoursSub => 'Pause all notifications.';

  @override
  String get emergencyPriority => 'Emergency Priority';

  @override
  String get emergencyPrioritySub => 'Override silent mode.';

  @override
  String get testNotification => 'Send Test Notification';

  @override
  String get loginHistoryTitle => 'Login History';

  @override
  String get currentSession => 'Current Session';

  @override
  String get previousSessions => 'Previous Sessions';

  @override
  String get noLoginHistory => 'No login history';

  @override
  String get clearHistory => 'Clear History';

  @override
  String get clearHistoryConfirm =>
      'Are you sure you want to clear all login history?';

  @override
  String get loginViaEmail => 'Sign in via Email';

  @override
  String get loginViaGoogle => 'Sign in via Google';

  @override
  String get justNow => 'Just now';

  @override
  String minutesAgo(int minutes) {
    return '$minutes minutes ago';
  }

  @override
  String hoursAgo(int hours) {
    return '$hours hours ago';
  }

  @override
  String daysAgo(int days) {
    return '$days days ago';
  }

  @override
  String get eventReminderNotifTitle => 'Event Reminder';

  @override
  String eventStartsIn(String title, int minutes) {
    return 'Event \"$title\" starts in $minutes minutes';
  }
}
