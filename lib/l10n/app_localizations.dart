import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
  ];

  /// No description provided for @appName.
  ///
  /// In vi, this message translates to:
  /// **'Schedulr'**
  String get appName;

  /// No description provided for @splashSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Đang khởi tạo không gian làm việc...'**
  String get splashSubtitle;

  /// No description provided for @skip.
  ///
  /// In vi, this message translates to:
  /// **'Bỏ qua'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp theo'**
  String get next;

  /// No description provided for @getStarted.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu'**
  String get getStarted;

  /// No description provided for @loginTitle.
  ///
  /// In vi, this message translates to:
  /// **'Schedulr'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Đơn giản hóa cuộc sống của bạn'**
  String get loginSubtitle;

  /// No description provided for @googleSignIn.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục với Google'**
  String get googleSignIn;

  /// No description provided for @or.
  ///
  /// In vi, this message translates to:
  /// **'HOẶC'**
  String get or;

  /// No description provided for @emailLabel.
  ///
  /// In vi, this message translates to:
  /// **'Địa chỉ Email'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu'**
  String get passwordLabel;

  /// No description provided for @login.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập'**
  String get login;

  /// No description provided for @forgotPassword.
  ///
  /// In vi, this message translates to:
  /// **'Quên mật khẩu?'**
  String get forgotPassword;

  /// No description provided for @noAccount.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có tài khoản?'**
  String get noAccount;

  /// No description provided for @signUp.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký'**
  String get signUp;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận mật khẩu'**
  String get confirmPasswordLabel;

  /// No description provided for @fullNameLabel.
  ///
  /// In vi, this message translates to:
  /// **'Họ và tên'**
  String get fullNameLabel;

  /// No description provided for @hasAccount.
  ///
  /// In vi, this message translates to:
  /// **'Đã có tài khoản?'**
  String get hasAccount;

  /// No description provided for @processing.
  ///
  /// In vi, this message translates to:
  /// **'Đang xử lý...'**
  String get processing;

  /// No description provided for @greetingMorning.
  ///
  /// In vi, this message translates to:
  /// **'Chào buổi sáng,'**
  String get greetingMorning;

  /// No description provided for @greetingAfternoon.
  ///
  /// In vi, this message translates to:
  /// **'Chào buổi chiều,'**
  String get greetingAfternoon;

  /// No description provided for @greetingEvening.
  ///
  /// In vi, this message translates to:
  /// **'Chào buổi tối,'**
  String get greetingEvening;

  /// No description provided for @progressToday.
  ///
  /// In vi, this message translates to:
  /// **'Tiến độ hôm nay'**
  String get progressToday;

  /// No description provided for @progressDesc.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đang làm rất tốt! Sắp hoàn thành rồi.'**
  String get progressDesc;

  /// No description provided for @priorityTasks.
  ///
  /// In vi, this message translates to:
  /// **'Công việc ưu tiên'**
  String get priorityTasks;

  /// No description provided for @upcomingEvents.
  ///
  /// In vi, this message translates to:
  /// **'Sự kiện sắp tới'**
  String get upcomingEvents;

  /// No description provided for @viewAll.
  ///
  /// In vi, this message translates to:
  /// **'Xem tất cả'**
  String get viewAll;

  /// No description provided for @viewCalendar.
  ///
  /// In vi, this message translates to:
  /// **'Xem Lịch'**
  String get viewCalendar;

  /// No description provided for @tasksOf.
  ///
  /// In vi, this message translates to:
  /// **'{completed} trên {total} công việc'**
  String tasksOf(int completed, int total);

  /// No description provided for @navHome.
  ///
  /// In vi, this message translates to:
  /// **'Trang chủ'**
  String get navHome;

  /// No description provided for @navCalendar.
  ///
  /// In vi, this message translates to:
  /// **'Lịch'**
  String get navCalendar;

  /// No description provided for @navTasks.
  ///
  /// In vi, this message translates to:
  /// **'Công việc'**
  String get navTasks;

  /// No description provided for @navAnalytics.
  ///
  /// In vi, this message translates to:
  /// **'Thống kê'**
  String get navAnalytics;

  /// No description provided for @navSettings.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt'**
  String get navSettings;

  /// No description provided for @monthView.
  ///
  /// In vi, this message translates to:
  /// **'Tháng'**
  String get monthView;

  /// No description provided for @weekView.
  ///
  /// In vi, this message translates to:
  /// **'Tuần'**
  String get weekView;

  /// No description provided for @dayView.
  ///
  /// In vi, this message translates to:
  /// **'Ngày'**
  String get dayView;

  /// No description provided for @eisenhowerTitle.
  ///
  /// In vi, this message translates to:
  /// **'Ma trận Eisenhower'**
  String get eisenhowerTitle;

  /// No description provided for @eisenhowerDesc.
  ///
  /// In vi, this message translates to:
  /// **'Ưu tiên các công việc dựa trên mức độ khẩn cấp và quan trọng.'**
  String get eisenhowerDesc;

  /// No description provided for @doNow.
  ///
  /// In vi, this message translates to:
  /// **'Làm ngay'**
  String get doNow;

  /// No description provided for @schedule.
  ///
  /// In vi, this message translates to:
  /// **'Lên lịch'**
  String get schedule;

  /// No description provided for @delegateTask.
  ///
  /// In vi, this message translates to:
  /// **'Ủy thác'**
  String get delegateTask;

  /// No description provided for @eliminate.
  ///
  /// In vi, this message translates to:
  /// **'Loại bỏ'**
  String get eliminate;

  /// No description provided for @weeklyOverview.
  ///
  /// In vi, this message translates to:
  /// **'Tổng quan tuần'**
  String get weeklyOverview;

  /// No description provided for @productivityScore.
  ///
  /// In vi, this message translates to:
  /// **'Điểm hiệu suất'**
  String get productivityScore;

  /// No description provided for @tasksCompleted.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn thành công việc'**
  String get tasksCompleted;

  /// No description provided for @timeDistribution.
  ///
  /// In vi, this message translates to:
  /// **'Phân bổ thời gian'**
  String get timeDistribution;

  /// No description provided for @focusStats.
  ///
  /// In vi, this message translates to:
  /// **'Thống kê tập trung'**
  String get focusStats;

  /// No description provided for @activity30Days.
  ///
  /// In vi, this message translates to:
  /// **'Hoạt động 30 ngày'**
  String get activity30Days;

  /// No description provided for @smartSuggestions.
  ///
  /// In vi, this message translates to:
  /// **'Gợi ý thông minh'**
  String get smartSuggestions;

  /// No description provided for @settings.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt'**
  String get settings;

  /// No description provided for @settingsSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Quản lý tài khoản và tùy chỉnh trải nghiệm của bạn.'**
  String get settingsSubtitle;

  /// No description provided for @accountInfo.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin tài khoản'**
  String get accountInfo;

  /// No description provided for @security.
  ///
  /// In vi, this message translates to:
  /// **'Bảo mật & Quyền riêng tư'**
  String get security;

  /// No description provided for @notificationConfig.
  ///
  /// In vi, this message translates to:
  /// **'Cấu hình thông báo'**
  String get notificationConfig;

  /// No description provided for @appTheme.
  ///
  /// In vi, this message translates to:
  /// **'Giao diện ứng dụng'**
  String get appTheme;

  /// No description provided for @logout.
  ///
  /// In vi, this message translates to:
  /// **'Đăng xuất'**
  String get logout;

  /// No description provided for @logoutConfirm.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc muốn đăng xuất?'**
  String get logoutConfirm;

  /// No description provided for @cancel.
  ///
  /// In vi, this message translates to:
  /// **'Hủy'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In vi, this message translates to:
  /// **'Lưu'**
  String get save;

  /// No description provided for @edit.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh sửa'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In vi, this message translates to:
  /// **'Xóa'**
  String get delete;

  /// No description provided for @confirm.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận'**
  String get confirm;

  /// No description provided for @proBadge.
  ///
  /// In vi, this message translates to:
  /// **'Thành viên Pro'**
  String get proBadge;

  /// No description provided for @accountGroup.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản'**
  String get accountGroup;

  /// No description provided for @appGroup.
  ///
  /// In vi, this message translates to:
  /// **'Ứng dụng'**
  String get appGroup;

  /// No description provided for @versionInfo.
  ///
  /// In vi, this message translates to:
  /// **'Schedulr Phiên bản 2.4.0 (Build 108)'**
  String get versionInfo;

  /// No description provided for @copyright.
  ///
  /// In vi, this message translates to:
  /// **'© 2024 Schedulr Inc.'**
  String get copyright;

  /// No description provided for @addEvent.
  ///
  /// In vi, this message translates to:
  /// **'Thêm Sự Kiện'**
  String get addEvent;

  /// No description provided for @eventName.
  ///
  /// In vi, this message translates to:
  /// **'Tên sự kiện của bạn...'**
  String get eventName;

  /// No description provided for @start.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu'**
  String get start;

  /// No description provided for @end.
  ///
  /// In vi, this message translates to:
  /// **'Kết thúc'**
  String get end;

  /// No description provided for @allDay.
  ///
  /// In vi, this message translates to:
  /// **'Cả ngày'**
  String get allDay;

  /// No description provided for @category.
  ///
  /// In vi, this message translates to:
  /// **'Danh mục'**
  String get category;

  /// No description provided for @reminder.
  ///
  /// In vi, this message translates to:
  /// **'Nhắc nhở'**
  String get reminder;

  /// No description provided for @subTasks.
  ///
  /// In vi, this message translates to:
  /// **'Công việc con'**
  String get subTasks;

  /// No description provided for @addSubTask.
  ///
  /// In vi, this message translates to:
  /// **'Thêm việc'**
  String get addSubTask;

  /// No description provided for @saveEvent.
  ///
  /// In vi, this message translates to:
  /// **'Lưu Sự Kiện'**
  String get saveEvent;

  /// No description provided for @profileTitle.
  ///
  /// In vi, this message translates to:
  /// **'Hồ sơ cá nhân'**
  String get profileTitle;

  /// No description provided for @personalInfo.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin cơ bản'**
  String get personalInfo;

  /// No description provided for @securityAccount.
  ///
  /// In vi, this message translates to:
  /// **'Bảo mật & Tài khoản'**
  String get securityAccount;

  /// No description provided for @appCustomization.
  ///
  /// In vi, this message translates to:
  /// **'Tùy chỉnh ứng dụng'**
  String get appCustomization;

  /// No description provided for @changePassword.
  ///
  /// In vi, this message translates to:
  /// **'Đổi mật khẩu'**
  String get changePassword;

  /// No description provided for @changePasswordSub.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật mật khẩu mới'**
  String get changePasswordSub;

  /// No description provided for @twoFactorAuth.
  ///
  /// In vi, this message translates to:
  /// **'Xác thực 2 lớp'**
  String get twoFactorAuth;

  /// No description provided for @twoFactorProtect.
  ///
  /// In vi, this message translates to:
  /// **'Bảo vệ tài khoản'**
  String get twoFactorProtect;

  /// No description provided for @twoFactorEnabled.
  ///
  /// In vi, this message translates to:
  /// **'Đang bật'**
  String get twoFactorEnabled;

  /// No description provided for @twoFactorDisabled.
  ///
  /// In vi, this message translates to:
  /// **'Đang tắt'**
  String get twoFactorDisabled;

  /// No description provided for @loginHistory.
  ///
  /// In vi, this message translates to:
  /// **'Lịch sử đăng nhập'**
  String get loginHistory;

  /// No description provided for @loginHistorySub.
  ///
  /// In vi, this message translates to:
  /// **'Kiểm tra thiết bị'**
  String get loginHistorySub;

  /// No description provided for @logoutSub.
  ///
  /// In vi, this message translates to:
  /// **'Kết thúc phiên làm việc'**
  String get logoutSub;

  /// No description provided for @darkMode.
  ///
  /// In vi, this message translates to:
  /// **'Chế độ tối (Dark Mode)'**
  String get darkMode;

  /// No description provided for @language.
  ///
  /// In vi, this message translates to:
  /// **'Ngôn ngữ'**
  String get language;

  /// No description provided for @vietnamese.
  ///
  /// In vi, this message translates to:
  /// **'Tiếng Việt'**
  String get vietnamese;

  /// No description provided for @english.
  ///
  /// In vi, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @featureComingSoon.
  ///
  /// In vi, this message translates to:
  /// **'Tính năng đang phát triển'**
  String get featureComingSoon;

  /// No description provided for @notUpdated.
  ///
  /// In vi, this message translates to:
  /// **'Chưa cập nhật'**
  String get notUpdated;

  /// No description provided for @user.
  ///
  /// In vi, this message translates to:
  /// **'Người dùng'**
  String get user;

  /// No description provided for @fullName.
  ///
  /// In vi, this message translates to:
  /// **'Họ và tên'**
  String get fullName;

  /// No description provided for @email.
  ///
  /// In vi, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @phoneNumber.
  ///
  /// In vi, this message translates to:
  /// **'Số điện thoại'**
  String get phoneNumber;

  /// No description provided for @uid.
  ///
  /// In vi, this message translates to:
  /// **'UID'**
  String get uid;

  /// No description provided for @weekProgress.
  ///
  /// In vi, this message translates to:
  /// **'Tiến độ tuần này'**
  String get weekProgress;

  /// No description provided for @weekProgressDesc.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã hoàn thành {percent}% mục tiêu đã đề ra.'**
  String weekProgressDesc(int percent);

  /// No description provided for @viewDetails.
  ///
  /// In vi, this message translates to:
  /// **'Xem chi tiết'**
  String get viewDetails;

  /// No description provided for @editProfile.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh sửa thông tin'**
  String get editProfile;

  /// No description provided for @passwordResetSent.
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi email đặt lại mật khẩu. Vui lòng kiểm tra hộp thư.'**
  String get passwordResetSent;

  /// No description provided for @passwordResetFailed.
  ///
  /// In vi, this message translates to:
  /// **'Gửi email thất bại, vui lòng thử lại sau'**
  String get passwordResetFailed;

  /// No description provided for @twoFactorTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xác thực 2 lớp'**
  String get twoFactorTitle;

  /// No description provided for @twoFactorEnableMsg.
  ///
  /// In vi, this message translates to:
  /// **'Khi bật xác thực 2 lớp, mỗi lần đăng nhập bạn sẽ cần nhập thêm mã OTP 6 số để xác minh danh tính.'**
  String get twoFactorEnableMsg;

  /// No description provided for @twoFactorDisableMsg.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có muốn tắt xác thực 2 lớp? Tài khoản sẽ bớt an toàn hơn.'**
  String get twoFactorDisableMsg;

  /// No description provided for @twoFactorEnabledSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã bật xác thực 2 lớp thành công'**
  String get twoFactorEnabledSuccess;

  /// No description provided for @twoFactorDisabledSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã tắt xác thực 2 lớp'**
  String get twoFactorDisabledSuccess;

  /// No description provided for @enableAuth.
  ///
  /// In vi, this message translates to:
  /// **'Bật xác thực'**
  String get enableAuth;

  /// No description provided for @disable.
  ///
  /// In vi, this message translates to:
  /// **'Tắt'**
  String get disable;

  /// No description provided for @selectLanguage.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ngôn ngữ'**
  String get selectLanguage;

  /// No description provided for @languageChanged.
  ///
  /// In vi, this message translates to:
  /// **'Đã đổi ngôn ngữ thành công'**
  String get languageChanged;

  /// No description provided for @notificationTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo'**
  String get notificationTitle;

  /// No description provided for @managePreferences.
  ///
  /// In vi, this message translates to:
  /// **'Quản lý tùy chọn'**
  String get managePreferences;

  /// No description provided for @managePreferencesSub.
  ///
  /// In vi, this message translates to:
  /// **'Tùy chỉnh cách bạn nhận thông báo từ Schedulr.'**
  String get managePreferencesSub;

  /// No description provided for @generalSettings.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt chung'**
  String get generalSettings;

  /// No description provided for @pushNotifications.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo đẩy'**
  String get pushNotifications;

  /// No description provided for @pushNotificationsSub.
  ///
  /// In vi, this message translates to:
  /// **'Nhận thông báo tức thì trên màn hình khóa'**
  String get pushNotificationsSub;

  /// No description provided for @sound.
  ///
  /// In vi, this message translates to:
  /// **'Âm báo'**
  String get sound;

  /// No description provided for @soundSub.
  ///
  /// In vi, this message translates to:
  /// **'Phát âm thanh khi có thông báo mới'**
  String get soundSub;

  /// No description provided for @eventsCalendar.
  ///
  /// In vi, this message translates to:
  /// **'Sự kiện & Lịch'**
  String get eventsCalendar;

  /// No description provided for @eventReminder.
  ///
  /// In vi, this message translates to:
  /// **'Nhắc nhở trước sự kiện'**
  String get eventReminder;

  /// No description provided for @eventReminderSub.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo 15 phút trước khi bắt đầu'**
  String get eventReminderSub;

  /// No description provided for @weeklyReport.
  ///
  /// In vi, this message translates to:
  /// **'Báo cáo hàng tuần'**
  String get weeklyReport;

  /// No description provided for @weeklyReportSub.
  ///
  /// In vi, this message translates to:
  /// **'Tổng kết năng suất vào sáng Thứ Hai'**
  String get weeklyReportSub;

  /// No description provided for @quietHours.
  ///
  /// In vi, this message translates to:
  /// **'Giờ yên tĩnh'**
  String get quietHours;

  /// No description provided for @quietHoursSub.
  ///
  /// In vi, this message translates to:
  /// **'Tạm dừng tất cả thông báo.'**
  String get quietHoursSub;

  /// No description provided for @emergencyPriority.
  ///
  /// In vi, this message translates to:
  /// **'Ưu tiên khẩn cấp'**
  String get emergencyPriority;

  /// No description provided for @emergencyPrioritySub.
  ///
  /// In vi, this message translates to:
  /// **'Bỏ qua chế độ im lặng.'**
  String get emergencyPrioritySub;

  /// No description provided for @testNotification.
  ///
  /// In vi, this message translates to:
  /// **'Gửi thông báo test'**
  String get testNotification;

  /// No description provided for @loginHistoryTitle.
  ///
  /// In vi, this message translates to:
  /// **'Lịch sử đăng nhập'**
  String get loginHistoryTitle;

  /// No description provided for @currentSession.
  ///
  /// In vi, this message translates to:
  /// **'Phiên hiện tại'**
  String get currentSession;

  /// No description provided for @previousSessions.
  ///
  /// In vi, this message translates to:
  /// **'Phiên đăng nhập trước'**
  String get previousSessions;

  /// No description provided for @noLoginHistory.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có lịch sử đăng nhập'**
  String get noLoginHistory;

  /// No description provided for @clearHistory.
  ///
  /// In vi, this message translates to:
  /// **'Xóa lịch sử'**
  String get clearHistory;

  /// No description provided for @clearHistoryConfirm.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc muốn xóa toàn bộ lịch sử đăng nhập?'**
  String get clearHistoryConfirm;

  /// No description provided for @loginViaEmail.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập qua Email'**
  String get loginViaEmail;

  /// No description provided for @loginViaGoogle.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập qua Google'**
  String get loginViaGoogle;

  /// No description provided for @justNow.
  ///
  /// In vi, this message translates to:
  /// **'Vừa xong'**
  String get justNow;

  /// No description provided for @minutesAgo.
  ///
  /// In vi, this message translates to:
  /// **'{minutes} phút trước'**
  String minutesAgo(int minutes);

  /// No description provided for @hoursAgo.
  ///
  /// In vi, this message translates to:
  /// **'{hours} giờ trước'**
  String hoursAgo(int hours);

  /// No description provided for @daysAgo.
  ///
  /// In vi, this message translates to:
  /// **'{days} ngày trước'**
  String daysAgo(int days);

  /// No description provided for @eventReminderNotifTitle.
  ///
  /// In vi, this message translates to:
  /// **'Nhắc nhở sự kiện'**
  String get eventReminderNotifTitle;

  /// No description provided for @eventStartsIn.
  ///
  /// In vi, this message translates to:
  /// **'Sự kiện \"{title}\" bắt đầu sau {minutes} phút'**
  String eventStartsIn(String title, int minutes);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
