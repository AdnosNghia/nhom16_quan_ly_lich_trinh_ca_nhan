# DANH SÁCH CHỨC NĂNG HỆ THỐNG — Schedulr App

> **Ghi chú:** `(x)` = đã thực hiện · `( )` = chưa thực hiện / đang phát triển

---

## 1. MÀN HÌNH KHỞI ĐỘNG (SplashScreen)

| # | Chức năng | Mô tả | Trạng thái |
|---|-----------|-------|------------|
| 1.1 | Khởi tạo database | Tự động tạo 5 bảng SQLite + seed 4 danh mục mặc định khi chạy lần đầu | (x) |
| 1.2 | Khởi tạo Provider | Đăng ký 5 ChangeNotifier (Theme, Auth, Event, Category, Task) vào MultiProvider | (x) |
| 1.3 | Khóa orientation | Giữ màn hình ở chế độ dọc (portrait) | (x) |
| 1.4 | Kiểm tra trạng thái đăng nhập | Gọi AuthProvider.checkLoginStatus() để kiểm tra session từ DB | (x) |
| 1.5 | Hiệu ứng chờ | Hiển thị logo + progress indicator + subtitle trong 2 giây | (x) |
| 1.6 | Điều hướng tự động | Chuyển đến Dashboard (đã đăng nhập) hoặc Onboarding (chưa đăng nhập) | (x) |
| 1.7 | Gradient nền | RadialGradient tím (#7B74FF → #4D41DF) | (x) |

---

## 2. MÀN HÌNH ONBOARDING (OnboardingScreen)

| # | Chức năng | Mô tả | Trạng thái |
|---|-----------|-------|------------|
| 2.1 | PageView 3 trang | Trượt giữa 3 slide giới thiệu: Lập lịch thông minh, Nhắc nhở thông minh, Phân tích hiệu suất | (x) |
| 2.2 | Indicator động | 3 chấm tròn, chấm active có hiệu ứng width mở rộng (32px) | (x) |
| 2.3 | Nút Skip | Bỏ qua onboarding, chuyển thẳng đến Login | (x) |
| 2.4 | Nút Next / Bắt đầu | Trang 1-2: "Tiếp theo" → chuyển slide. Trang 3: "Bắt đầu" → đến Login | (x) |
| 2.5 | Animation container | Icon trong container bo góc, kích thước responsive theo LayoutBuilder | (x) |

---

## 3. LUỒNG XÁC THỰC (Authentication)

### 3.1 Đăng nhập (LoginScreen)

| # | Chức năng | Mô tả | Trạng thái |
|---|-----------|-------|------------|
| 3.1.1 | Form email/password | TextField với label, có nút ẩn/hiện mật khẩu | (x) |
| 3.1.2 | Validation cơ bản | Kiểm tra email và password không được để trống | (x) |
| 3.1.3 | Loading indicator | Button hiển thị CircularProgressIndicator + disable khi đang xử lý | (x) |
| 3.1.4 | Xác thực qua AuthProvider | Gọi AuthProvider.login(email, password) tập trung | (x) |
| 3.1.5 | Hiển thị lỗi | Text màu đỏ báo lỗi "Email chưa được đăng ký", "Mật khẩu không đúng" | (x) |
| 3.1.6 | Lưu session | Tự động lưu user_logged_in=true + user_email + user_name vào DB | (x) |
| 3.1.7 | Điều hướng sau login | Chuyển đến Dashboard sau khi đăng nhập thành công | (x) |
| 3.1.8 | Nút Quên mật khẩu | Hiển thị SnackBar "Tính năng đang phát triển" | (x) |
| 3.1.9 | Nút Đăng ký | Chuyển đến RegisterScreen | (x) |
| 3.1.10 | Đăng nhập Google | Nút placeholder "Tiếp tục với Google" — chưa tích hợp | (x) |
| 3.1.11 | Giao diện card | Form nằm trong container bo góc, có border + shadow | (x) |
| 3.1.12 | Responsive layout | ConstrainedBox với maxWidth, SingleChildScrollView hỗ trợ màn hình nhỏ | (x) |

### 3.2 Đăng ký (RegisterScreen)

| # | Chức năng | Mô tả | Trạng thái |
|---|-----------|-------|------------|
| 3.2.1 | Form 4 trường | Họ tên, Email, Mật khẩu, Xác nhận mật khẩu | (x) |
| 3.2.2 | Validation đầy đủ | Không trống, email chứa '@', password >= 6 ký tự, confirm trùng khớp | (x) |
| 3.2.3 | Loading + disable button | Hiển thị spinner + text "Đang xử lý..." khi register | (x) |
| 3.2.4 | Đăng ký qua AuthProvider | Gọi AuthProvider.register(name, email, password) | (x) |
| 3.2.5 | Kiểm tra email tồn tại | Báo lỗi nếu email đã được đăng ký trước đó | (x) |
| 3.2.6 | Lưu tên theo user | Lưu `user_{email}_name` riêng thay vì key dùng chung | (x) |
| 3.2.7 | Transaction DB | INSERT đồng bộ các settings key trong transaction | (x) |
| 3.2.8 | Điều hướng sau đăng ký | pushNamedAndRemoveUntil đến Dashboard (xóa toàn bộ stack) | (x) |
| 3.2.9 | Nút trở về Đăng nhập | Footer link "Đã có tài khoản? Đăng nhập" → pop() | (x) |
| 3.2.10 | Đăng ký Google | Nút placeholder — chưa tích hợp | (x) |

### 3.3 Quản lý phiên (AuthProvider)

| # | Chức năng | Mô tả | Trạng thái |
|---|-----------|-------|------------|
| 3.3.1 | checkLoginStatus | Kiểm tra user_logged_in từ DB, load user info nếu có | (x) |
| 3.3.2 | login | Xác thực email/password, set User entity, thông báo listener | (x) |
| 3.3.3 | register | Tạo tài khoản mới, set User entity, thông báo listener | (x) |
| 3.3.4 | logout | Set user_logged_in=false, clear User entity | (x) |
| 3.3.5 | clearError | Reset errorMessage | (x) |
| 3.3.6 | State quản lý | isLoading, isLoggedIn, isInitialized, errorMessage, user | (x) |
| 3.3.7 | Tích hợp REST API | Sẵn sàng chuyển từ local DB sang ApiService + AuthRepository (Phase 3) | ( ) |

---

## 4. MÀN HÌNH TRANG CHỦ (DashboardScreen)

| # | Chức năng | Mô tả | Trạng thái |
|---|-----------|-------|------------|
| 4.1 | Header user | Avatar + "Chào buổi sáng" + tên động từ AuthProvider.user.name | (x) |
| 4.2 | Notification bell | IconButton chuông thông báo (placeholder) | (x) |
| 4.3 | Week Strip | Thanh ngang 7 ngày trong tuần, có chấm tròn báo hiệu sự kiện | (x) |
| 4.4 | Highlight ngày hiện tại | Ô ngày hiện tại có màu primaryContainer khác biệt | (x) |
| 4.5 | Progress Card | CircularProgressIndicator + "X trên Y công việc" từ TaskProvider | (x) |
| 4.6 | Priority Tasks | 3 sự kiện sắp tới chưa hoàn thành, có border màu danh mục | (x) |
| 4.7 | Upcoming Events | 3 sự kiện sắp tới, card hiển thị tháng/ngày + giờ | (x) |
| 4.8 | View Calendar | TextButton → đến CalendarScreen | (x) |
| 4.9 | View All tasks | TextButton → đến TasksScreen | (x) |
| 4.10 | FAB thêm sự kiện | FloatingActionButton → đến AddEventScreen | (x) |
| 4.11 | Bottom Navigation | 5 tab: Trang chủ, Lịch, Công việc, Thống kê, Cài đặt | (x) |
| 4.12 | Responsive spacing | Padding và kích thước thích ứng theo màn hình | (x) |
| 4.13 | Lazy load dữ liệu | Gọi EventProvider.ensureLoaded() + TaskProvider.ensureLoaded() trong initState | (x) |

---

## 5. MÀN HÌNH LỊCH (CalendarScreen)

| # | Chức năng | Mô tả | Trạng thái |
|---|-----------|-------|------------|
| 5.1 | Lưới tháng | Hiển thị đầy đủ các ngày trong tháng, 7 cột (T2-CN) | (x) |
| 5.2 | Chấm sự kiện | Ngày có sự kiện hiển thị chấm tròn màu theo danh mục | (x) |
| 5.3 | Chuyển tháng | Nút < > điều hướng tháng trước/sau | (x) |
| 5.4 | Chọn ngày | Nhấn vào ngày → cập nhật _selectedDate + load agenda | (x) |
| 5.5 | Highlight ngày được chọn | Ô ngày có viền primary | (x) |
| 5.6 | Agenda | Danh sách sự kiện của ngày được chọn, hiển thị giờ + màu danh mục | (x) |
| 5.7 | Xóa sự kiện | Dialog xác nhận → eventProvider.deleteEvent(id) → refresh | (x) |
| 5.8 | Segmented control | Toggle Tháng/Tuần/Ngày (UI toggle, logic đang xử lý) | (x) |
| 5.9 | FAB thêm sự kiện | Nút + → AddEventScreen | (x) |
| 5.10 | Bottom Navigation | 5 tab, giữ index Calendar | (x) |
| 5.11 | Responsive calendar | Kích thước ô ngày tự động điều chỉnh | (x) |

---

## 6. THÊM SỰ KIỆN (AddEventScreen)

| # | Chức năng | Mô tả | Trạng thái |
|---|-----------|-------|------------|
| 6.1 | Title | TextField lớn (font 32px), tự động focus | (x) |
| 6.2 | Chọn ngày bắt đầu/kết thúc | DatePicker + TimePicker | (x) |
| 6.3 | Mũi tên thời gian | Hiển thị → giữa start và end | (x) |
| 6.4 | Toggle Cả ngày | Switch bật/tắt | (x) |
| 6.5 | Chọn danh mục | ChoiceChips từ CategoryProvider (Công việc, Học tập, Cá nhân, Sức khỏe) | (x) |
| 6.6 | Chọn nhắc nhở | Radio: 5 phút / 15 phút / 30 phút | (x) |
| 6.7 | Quản lý Subtask | Thêm, toggle checkbox, xóa subtask | (x) |
| 6.8 | Lưu sự kiện | eventProvider.addEvent(event) → INSERT vào DB + pop | (x) |
| 6.9 | Validate title | Kiểm tra title không trống trước khi lưu | (x) |
| 6.10 | Responsive form | SingleChildScrollView cho màn hình nhỏ | (x) |
| 6.11 | Chỉnh sửa sự kiện | Load dữ liệu cũ, cập nhật thay vì tạo mới | ( ) |

---

## 7. MÀN HÌNH CÔNG VIỆC — Eisenhower Matrix (TasksScreen)

| # | Chức năng | Mô tả | Trạng thái |
|---|-----------|-------|------------|
| 7.1 | 4 Quadrants | Làm ngay (khẩn+qt), Lên lịch (ko khẩn+qt), Ủy thác (khẩn+ko qt), Loại bỏ (ko khẩn+ko qt) | (x) |
| 7.2 | Header quadrant | Mỗi ô có icon + tiêu đề + badge số lượng | (x) |
| 7.3 | Thêm task | Dialog nhập tên, tự động phân vào đúng quadrant | (x) |
| 7.4 | Toggle hoàn thành | Checkbox → taskProvider.toggleTaskComplete(id) | (x) |
| 7.5 | Xóa task | Nút ✕ → taskProvider.deleteTask(id) | (x) |
| 7.6 | Dữ liệu từ DB | Lưu tasks vào SQLite, load qua TaskProvider | (x) |
| 7.7 | Bottom Navigation | 5 tab, giữ index Tasks | (x) |

---

## 8. MÀN HÌNH THỐNG KÊ (AnalyticsScreen)

| # | Chức năng | Mô tả | Trạng thái |
|---|-----------|-------|------------|
| 8.1 | Header tiến độ | Mô tả trạng thái + điểm hiệu suất (85/100) + progress bar | (x) |
| 8.2 | Bar chart | 7 ngày gần nhất, số task hoàn thành mỗi ngày | (x) |
| 8.3 | Donut chart | Phân bổ thời gian (Công việc 45%, Sức khỏe 25%, Cá nhân 20%) — Custom Painter | (x) |
| 8.4 | Legend | Chú thích màu cho từng danh mục | (x) |
| 8.5 | Focus Stats | Tổng sự kiện, đã hoàn thành, còn lại từ EventProvider | (x) |
| 8.6 | Heatmap legend | "Ít ■■■■■■■■ Nhiều" — UI trực quan | (x) |
| 8.7 | Smart Suggestions | Gợi ý dựa trên dữ liệu thực (đỉnh cao buổi sáng, tiến độ...) | (x) |
| 8.8 | Responsive layout | 1 cột trên màn nhỏ, 2 cột trên màn lớn | (x) |
| 8.9 | Bottom Navigation | 5 tab, giữ index Analytics | (x) |
| 8.10 | Biểu đồ nâng cao | Tích hợp fl_chart để thay thế Custom Painter | ( ) |

---

## 9. MÀN HÌNH CÀI ĐẶT (SettingsScreen)

| # | Chức năng | Mô tả | Trạng thái |
|---|-----------|-------|------------|
| 9.1 | Profile card | Avatar + tên + email động từ AuthProvider.user | (x) |
| 9.2 | Chip "Thành viên Pro" | Chip tĩnh, UI decoration | (x) |
| 9.3 | Nhóm Tài khoản | Thông tin cá nhân → /account_info, Bảo mật (placeholder) | (x) |
| 9.4 | Nhóm Ứng dụng | Cấu hình thông báo → /notification_settings, Giao diện → /app_theme | (x) |
| 9.5 | Nút Đăng xuất | Dialog xác nhận → AuthProvider.logout() → /login | (x) |
| 9.6 | Version info | "Schedulr Phiên bản 2.4.0 (Build 108)" | (x) |
| 9.7 | Bottom Navigation | 5 tab, giữ index Settings | (x) |

---

## 10. HỒ SƠ CÁ NHÂN (AccountInfoScreen)

| # | Chức năng | Mô tả | Trạng thái |
|---|-----------|-------|------------|
| 10.1 | Avatar + camera | CircleAvatar + icon camera overlay | (x) |
| 10.2 | Tên + tagline | Nguyễn Minh Tuấn + "Sinh viên năm 3 • ĐHBK" | (x) |
| 10.3 | Thông tin cơ bản | Email, SĐT, Địa chỉ (dữ liệu tĩnh mẫu) | (x) |
| 10.4 | Tiến độ tuần | Progress bar 85% + nút "Xem chi tiết" (placeholder) | (x) |
| 10.5 | Bảo mật & Tài khoản | Đổi mật khẩu, Xác thực 2 lớp, Lịch sử đăng nhập, Đăng xuất | (x) |
| 10.6 | Tùy chỉnh ứng dụng | Dark mode toggle, Ngôn ngữ dropdown (Tiếng Việt) | (x) |
| 10.7 | Responsive layout | Thích ứng giữa phone và tablet | (x) |

---

## 11. CÀI ĐẶT THÔNG BÁO (NotificationSettingsScreen)

| # | Chức năng | Mô tả | Trạng thái |
|---|-----------|-------|------------|
| 11.1 | Thông báo đẩy | Switch bật/tắt (custom AppToggle widget) | (x) |
| 11.2 | Âm báo | Switch bật/tắt | (x) |
| 11.3 | Nhắc nhở sự kiện | Switch bật/tắt (mặc định 15 phút trước) | (x) |
| 11.4 | Báo cáo hàng tuần | Switch bật/tắt (sáng Thứ 2) | (x) |
| 11.5 | Giờ yên tĩnh | Card thông tin (UI tĩnh) | (x) |
| 11.6 | Ưu tiên khẩn cấp | Card thông tin (UI tĩnh) | (x) |
| 11.7 | Local notifications | Tích hợp flutter_local_notifications để gửi thông báo thực | ( ) |

---

## 12. GIAO DIỆN ỨNG DỤNG (AppThemeScreen)

| # | Chức năng | Mô tả | Trạng thái |
|---|-----------|-------|------------|
| 12.1 | Chế độ hiển thị | 3 card: Sáng, Tối, Hệ thống — checkmark trên card active | (x) |
| 12.2 | Màu chủ đạo | 6 màu: Tím, Hồng, Xanh lục, Cam, Xám, Tím đậm | (x) |
| 12.3 | Áp dụng thay đổi | ThemeProvider.setThemeMode() + setColorSeed() + SnackBar xác nhận | (x) |
| 12.4 | Material 3 dynamic | ColorScheme.fromSeed() + google_fonts Plus Jakarta Sans | (x) |
| 12.5 | Lưu theme runtime | ThemeProvider cache light/dark theme, thay đổi tức thì | (x) |
| 12.6 | Lưu theme vĩnh viễn | Persist lựa chọn theme vào SharedPreferences/DB | ( ) |

---

## 13. THANH ĐIỀU HƯỚNG (AppBottomNav)

| # | Chức năng | Mô tả | Trạng thái |
|---|-----------|-------|------------|
| 13.1 | 5 tab | Trang chủ, Lịch, Công việc, Thống kê, Cài đặt | (x) |
| 13.2 | Icon động | Filled icon khi active, outlined icon khi inactive | (x) |
| 13.3 | GestureDetector | Nhấn để chuyển tab bằng pushReplacementNamed | (x) |
| 13.4 | Highlight tab | Màu primary + nền primaryContainer cho tab active | (x) |

---

## 14. DATA LAYER

| # | Chức năng | Mô tả | Trạng thái |
|---|-----------|-------|------------|
| 14.1 | SQLite database | 5 bảng: events, categories, subtasks, tasks, settings | (x) |
| 14.2 | AppDatabase (Singleton) | Lazy initialization, factory constructor | (x) |
| 14.3 | Seed categories | 4 danh mục mặc định: Công việc (tím), Học tập (cam), Cá nhân (đỏ), Sức khỏe (xanh lục) | (x) |
| 14.4 | EventRepository | CRUD + lọc theo ngày + thống kê + subtasks | (x) |
| 14.5 | TaskRepository | CRUD + toggle + thống kê theo ngày cho Eisenhower | (x) |
| 14.6 | CategoryRepository | CRUD danh mục | (x) |
| 14.7 | AuthRepository | Tách logic auth khỏi AuthProvider — gọi REST API | ( ) |
| 14.8 | ApiService | HTTP client tập trung với token interceptor + refresh token | ( ) |
| 14.9 | Migration DB | Nâng cấp từ v1 lên v2 khi thêm bảng users | ( ) |

---

## 15. RESPONSIVE & UI SYSTEM

| # | Chức năng | Mô tả | Trạng thái |
|---|-----------|-------|------------|
| 15.1 | ResponsiveHelper | scaleWidth/Height/Font dựa trên reference 375x812 | (x) |
| 15.2 | AppDimensions | Spacing constants (xs-xl) + border radius + responsive methods | (x) |
| 15.3 | AppColors | Material 3 color tokens (light + dark) | (x) |
| 15.4 | AppStrings | Toàn bộ string UI bằng tiếng Việt, tập trung | (x) |
| 15.5 | 3 breakpoints | Nhỏ (<400dp), Vừa (400-600dp), Lớn (≥600dp) | (x) |

---

## 16. STATE MANAGEMENT (Providers)

| # | Provider | Trạng thái |
|---|----------|------------|
| 16.1 | **AuthProvider** — Quản lý xác thực, User entity, session | (x) |
| 16.2 | **ThemeProvider** — ThemeMode (light/dark/system) + 6 color seed, theme caching | (x) |
| 16.3 | **EventProvider** — Event CRUD, lọc theo ngày, thống kê | (x) |
| 16.4 | **CategoryProvider** — Load danh mục từ DB, lookup theo id | (x) |
| 16.5 | **TaskProvider** — Task CRUD, phân loại Eisenhower, thống kê | (x) |

---

## 17. TÍNH NĂNG SẮP TỚI (Phase 3 — API & Authentication)

| # | Chức năng | Mô tả | Trạng thái |
|---|-----------|-------|------------|
| 17.1 | REST API Auth | Đăng nhập/đăng ký qua backend thay vì local DB | ( ) |
| 17.2 | JWT Token | Lưu token, auto refresh, interceptor | ( ) |
| 17.3 | Đăng nhập Google | OAuth2 với Google | ( ) |
| 17.4 | Quên mật khẩu | Gửi email reset password | ( ) |
| 17.5 | Local Notifications | Gửi thông báo nhắc nhở sự kiện qua flutter_local_notifications | ( ) |
| 17.6 | Chỉnh sửa sự kiện | Load dữ liệu cũ + cập nhật thay vì chỉ thêm mới | ( ) |
| 17.7 | Lưu theme vĩnh viễn | Persist theme mode + color seed vào SharedPreferences | ( ) |
| 17.8 | Biểu đồ nâng cao | fl_chart thay Custom Painter cho donut chart | ( ) |
| 17.9 | Search/Filter | Tìm kiếm và lọc sự kiện | ( ) |
| 17.10 | Recurring events | Xử lý sự kiện lặp lại (hàng ngày/tuần/tháng) | ( ) |
| 17.11 | Data export | Xuất lịch dạng .ics | ( ) |
| 17.12 | Biometric lock | Khóa ứng dụng bằng vân tay/FaceID | ( ) |

---

*Tài liệu được tạo ngày 16/05/2026 — dựa trên mã nguồn Schedulr Flutter App và luồng hoạt động hệ thống.*
