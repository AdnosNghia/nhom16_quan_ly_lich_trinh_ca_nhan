// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appName => 'Schedulr';

  @override
  String get splashSubtitle => 'Đang khởi tạo không gian làm việc...';

  @override
  String get skip => 'Bỏ qua';

  @override
  String get next => 'Tiếp theo';

  @override
  String get getStarted => 'Bắt đầu';

  @override
  String get loginTitle => 'Schedulr';

  @override
  String get loginSubtitle => 'Đơn giản hóa cuộc sống của bạn';

  @override
  String get googleSignIn => 'Tiếp tục với Google';

  @override
  String get or => 'HOẶC';

  @override
  String get emailLabel => 'Địa chỉ Email';

  @override
  String get passwordLabel => 'Mật khẩu';

  @override
  String get login => 'Đăng nhập';

  @override
  String get forgotPassword => 'Quên mật khẩu?';

  @override
  String get noAccount => 'Chưa có tài khoản?';

  @override
  String get signUp => 'Đăng ký';

  @override
  String get confirmPasswordLabel => 'Xác nhận mật khẩu';

  @override
  String get fullNameLabel => 'Họ và tên';

  @override
  String get hasAccount => 'Đã có tài khoản?';

  @override
  String get processing => 'Đang xử lý...';

  @override
  String get greetingMorning => 'Chào buổi sáng,';

  @override
  String get greetingAfternoon => 'Chào buổi chiều,';

  @override
  String get greetingEvening => 'Chào buổi tối,';

  @override
  String get progressToday => 'Tiến độ hôm nay';

  @override
  String get progressDesc => 'Bạn đang làm rất tốt! Sắp hoàn thành rồi.';

  @override
  String get priorityTasks => 'Công việc ưu tiên';

  @override
  String get upcomingEvents => 'Sự kiện sắp tới';

  @override
  String get viewAll => 'Xem tất cả';

  @override
  String get viewCalendar => 'Xem Lịch';

  @override
  String tasksOf(int completed, int total) {
    return '$completed trên $total công việc';
  }

  @override
  String get navHome => 'Trang chủ';

  @override
  String get navCalendar => 'Lịch';

  @override
  String get navTasks => 'Công việc';

  @override
  String get navAnalytics => 'Thống kê';

  @override
  String get navSettings => 'Cài đặt';

  @override
  String get monthView => 'Tháng';

  @override
  String get weekView => 'Tuần';

  @override
  String get dayView => 'Ngày';

  @override
  String get eisenhowerTitle => 'Ma trận Eisenhower';

  @override
  String get eisenhowerDesc =>
      'Ưu tiên các công việc dựa trên mức độ khẩn cấp và quan trọng.';

  @override
  String get doNow => 'Làm ngay';

  @override
  String get schedule => 'Lên lịch';

  @override
  String get delegateTask => 'Ủy thác';

  @override
  String get eliminate => 'Loại bỏ';

  @override
  String get weeklyOverview => 'Tổng quan tuần';

  @override
  String get productivityScore => 'Điểm hiệu suất';

  @override
  String get tasksCompleted => 'Hoàn thành công việc';

  @override
  String get timeDistribution => 'Phân bổ thời gian';

  @override
  String get focusStats => 'Thống kê tập trung';

  @override
  String get activity30Days => 'Hoạt động 30 ngày';

  @override
  String get smartSuggestions => 'Gợi ý thông minh';

  @override
  String get settings => 'Cài đặt';

  @override
  String get settingsSubtitle =>
      'Quản lý tài khoản và tùy chỉnh trải nghiệm của bạn.';

  @override
  String get accountInfo => 'Thông tin tài khoản';

  @override
  String get security => 'Bảo mật & Quyền riêng tư';

  @override
  String get notificationConfig => 'Cấu hình thông báo';

  @override
  String get appTheme => 'Giao diện ứng dụng';

  @override
  String get logout => 'Đăng xuất';

  @override
  String get logoutConfirm => 'Bạn có chắc muốn đăng xuất?';

  @override
  String get cancel => 'Hủy';

  @override
  String get save => 'Lưu';

  @override
  String get edit => 'Chỉnh sửa';

  @override
  String get delete => 'Xóa';

  @override
  String get confirm => 'Xác nhận';

  @override
  String get proBadge => 'Thành viên Pro';

  @override
  String get accountGroup => 'Tài khoản';

  @override
  String get appGroup => 'Ứng dụng';

  @override
  String get versionInfo => 'Schedulr Phiên bản 2.4.0 (Build 108)';

  @override
  String get copyright => '© 2024 Schedulr Inc.';

  @override
  String get addEvent => 'Thêm Sự Kiện';

  @override
  String get eventName => 'Tên sự kiện của bạn...';

  @override
  String get start => 'Bắt đầu';

  @override
  String get end => 'Kết thúc';

  @override
  String get allDay => 'Cả ngày';

  @override
  String get category => 'Danh mục';

  @override
  String get reminder => 'Nhắc nhở';

  @override
  String get subTasks => 'Công việc con';

  @override
  String get addSubTask => 'Thêm việc';

  @override
  String get saveEvent => 'Lưu Sự Kiện';

  @override
  String get profileTitle => 'Hồ sơ cá nhân';

  @override
  String get personalInfo => 'Thông tin cơ bản';

  @override
  String get securityAccount => 'Bảo mật & Tài khoản';

  @override
  String get appCustomization => 'Tùy chỉnh ứng dụng';

  @override
  String get changePassword => 'Đổi mật khẩu';

  @override
  String get changePasswordSub => 'Cập nhật mật khẩu mới';

  @override
  String get twoFactorAuth => 'Xác thực 2 lớp';

  @override
  String get twoFactorProtect => 'Bảo vệ tài khoản';

  @override
  String get twoFactorEnabled => 'Đang bật';

  @override
  String get twoFactorDisabled => 'Đang tắt';

  @override
  String get loginHistory => 'Lịch sử đăng nhập';

  @override
  String get loginHistorySub => 'Kiểm tra thiết bị';

  @override
  String get logoutSub => 'Kết thúc phiên làm việc';

  @override
  String get darkMode => 'Chế độ tối (Dark Mode)';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get vietnamese => 'Tiếng Việt';

  @override
  String get english => 'English';

  @override
  String get featureComingSoon => 'Tính năng đang phát triển';

  @override
  String get notUpdated => 'Chưa cập nhật';

  @override
  String get user => 'Người dùng';

  @override
  String get fullName => 'Họ và tên';

  @override
  String get email => 'Email';

  @override
  String get phoneNumber => 'Số điện thoại';

  @override
  String get uid => 'UID';

  @override
  String get weekProgress => 'Tiến độ tuần này';

  @override
  String weekProgressDesc(int percent) {
    return 'Bạn đã hoàn thành $percent% mục tiêu đã đề ra.';
  }

  @override
  String get viewDetails => 'Xem chi tiết';

  @override
  String get editProfile => 'Chỉnh sửa thông tin';

  @override
  String get passwordResetSent =>
      'Đã gửi email đặt lại mật khẩu. Vui lòng kiểm tra hộp thư.';

  @override
  String get passwordResetFailed => 'Gửi email thất bại, vui lòng thử lại sau';

  @override
  String get twoFactorTitle => 'Xác thực 2 lớp';

  @override
  String get twoFactorEnableMsg =>
      'Khi bật xác thực 2 lớp, mỗi lần đăng nhập bạn sẽ cần nhập thêm mã OTP 6 số để xác minh danh tính.';

  @override
  String get twoFactorDisableMsg =>
      'Bạn có muốn tắt xác thực 2 lớp? Tài khoản sẽ bớt an toàn hơn.';

  @override
  String get twoFactorEnabledSuccess => 'Đã bật xác thực 2 lớp thành công';

  @override
  String get twoFactorDisabledSuccess => 'Đã tắt xác thực 2 lớp';

  @override
  String get enableAuth => 'Bật xác thực';

  @override
  String get disable => 'Tắt';

  @override
  String get selectLanguage => 'Chọn ngôn ngữ';

  @override
  String get languageChanged => 'Đã đổi ngôn ngữ thành công';

  @override
  String get notificationTitle => 'Thông báo';

  @override
  String get managePreferences => 'Quản lý tùy chọn';

  @override
  String get managePreferencesSub =>
      'Tùy chỉnh cách bạn nhận thông báo từ Schedulr.';

  @override
  String get generalSettings => 'Cài đặt chung';

  @override
  String get pushNotifications => 'Thông báo đẩy';

  @override
  String get pushNotificationsSub =>
      'Nhận thông báo tức thì trên màn hình khóa';

  @override
  String get sound => 'Âm báo';

  @override
  String get soundSub => 'Phát âm thanh khi có thông báo mới';

  @override
  String get eventsCalendar => 'Sự kiện & Lịch';

  @override
  String get eventReminder => 'Nhắc nhở trước sự kiện';

  @override
  String get eventReminderSub => 'Thông báo 15 phút trước khi bắt đầu';

  @override
  String get weeklyReport => 'Báo cáo hàng tuần';

  @override
  String get weeklyReportSub => 'Tổng kết năng suất vào sáng Thứ Hai';

  @override
  String get quietHours => 'Giờ yên tĩnh';

  @override
  String get quietHoursSub => 'Tạm dừng tất cả thông báo.';

  @override
  String get emergencyPriority => 'Ưu tiên khẩn cấp';

  @override
  String get emergencyPrioritySub => 'Bỏ qua chế độ im lặng.';

  @override
  String get testNotification => 'Gửi thông báo test';

  @override
  String get loginHistoryTitle => 'Lịch sử đăng nhập';

  @override
  String get currentSession => 'Phiên hiện tại';

  @override
  String get previousSessions => 'Phiên đăng nhập trước';

  @override
  String get noLoginHistory => 'Chưa có lịch sử đăng nhập';

  @override
  String get clearHistory => 'Xóa lịch sử';

  @override
  String get clearHistoryConfirm =>
      'Bạn có chắc muốn xóa toàn bộ lịch sử đăng nhập?';

  @override
  String get loginViaEmail => 'Đăng nhập qua Email';

  @override
  String get loginViaGoogle => 'Đăng nhập qua Google';

  @override
  String get justNow => 'Vừa xong';

  @override
  String minutesAgo(int minutes) {
    return '$minutes phút trước';
  }

  @override
  String hoursAgo(int hours) {
    return '$hours giờ trước';
  }

  @override
  String daysAgo(int days) {
    return '$days ngày trước';
  }

  @override
  String get eventReminderNotifTitle => 'Nhắc nhở sự kiện';

  @override
  String eventStartsIn(String title, int minutes) {
    return 'Sự kiện \"$title\" bắt đầu sau $minutes phút';
  }
}
