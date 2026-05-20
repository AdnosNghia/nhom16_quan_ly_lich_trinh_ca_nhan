# Những Gì Đã Làm - Personal Scheduler App (Schedulr)

## Tổng quan
Đã xây dựng ứng dụng Flutter **Schedulr** - Personal Scheduler App dựa trên:
- **Spec document**: `Plan/stitch_schedulr_mobile_ui_kit/personal_scheduler_app_spec (1).md`
- **UI Kit HTML**: 13 màn hình HTML trong `Plan/stitch_schedulr_mobile_ui_kit/`
- **Design System**: `Plan/stitch_schedulr_mobile_ui_kit/schedulr_design_system/DESIGN.md`

## Kiến trúc
Clean Architecture với 3 layers + State Management:
- `lib/core/` - Constants, theme, utils
- `lib/domain/` - Entities (Event, Category, SubTask, TaskItem, User)
- `lib/data/` - Repositories (Firestore)
- `lib/features/` - Feature modules (auth, calendar, tasks, analytics, settings, splash, onboarding, dashboard)
- `lib/shared/` - Shared widgets + Providers (state management)

## Package đã thêm
- `google_fonts: ^6.1.0` (font Plus Jakarta Sans)
- `provider: ^6.1.2` (state management)
- `intl: ^0.20.2` (định dạng ngày tháng)
- `firebase_core: ^3.12.1` (Firebase init)
- `firebase_auth: ^5.5.1` (Firebase Authentication — Email/Password)
- `cloud_firestore: ^5.6.5` (Firestore database)
- `uuid: ^4.5.1` (sinh id cho documents)

## Package đã xóa
- `sqflite: ^2.4.2` — chuyển sang Firestore
- `path: ^1.9.1` — không cần đường dẫn local

## Database (Firestore — cloud, không còn SQLite)
3 collections:
- **events/{id}** — id, title, description, startTime (ISO), endTime (ISO), location, categoryId, colorHex, isAllDay, isRecurring, recurrenceRule, reminderMinutes (list), isCompleted, createdAt, updatedAt
  - **events/{id}/subtasks/{id}** — subcollection: eventId, title, isCompleted, sortOrder
- **categories/{id}** — name, colorHex, iconCode (tự động seed khi collection rỗng)
- **tasks/{id}** — title, description, quadrant (0-3), isCompleted, dueDate (ISO), createdAt

## Chức năng đã implement (Phase 1 & 2)

### 1. Splash Screen
- Kiểm tra trạng thái đăng nhập qua **AuthProvider** (FirebaseAuth)
- Load categories từ Firestore (tự động seed nếu rỗng)
- Load song song auth + categories để giảm thời gian chờ
- Tự động chuyển đến Onboarding (nếu chưa login) hoặc Dashboard (nếu đã login)

### 2. Onboarding
- 3 slide giới thiệu (Lập lịch thông minh, Nhắc nhở thông minh, Phân tích hiệu suất)
- Skip/Next/Get Started đến Login

### 3. Authentication (Quản lý bởi AuthProvider — FirebaseAuth)
- **User Entity**: `lib/domain/entities/user.dart` — email + name
- **AuthProvider**: `lib/shared/providers/auth_provider.dart` — dùng `FirebaseAuth` SDK
  - `checkLoginStatus()` — Kiểm tra `FirebaseAuth.currentUser`
  - `login(email, password)` — `signInWithEmailAndPassword`
  - `register(name, email, password)` — `createUserWithEmailAndPassword` + `updateDisplayName`
  - `logout()` — `signOut()`
  - `clearError()` — Reset thông báo lỗi
  - State: `user`, `isLoading`, `isLoggedIn`, `isInitialized`, `errorMessage`
- **LoginScreen**: Dùng AuthProvider, có loading indicator, error message
- **RegisterScreen**: Dùng AuthProvider
- **SplashScreen**: Dùng AuthProvider
- **SettingsScreen**: Logout gọi `AuthProvider.logout()`, hiển thị tên/email động từ provider
- **DashboardScreen**: Hiển thị tên user động từ AuthProvider

### 4. Dashboard
- **Week strip**: Hiển thị 7 ngày trong tuần, có chấm tròn nếu ngày đó có sự kiện. Chọn ngày → cập nhật toàn bộ section bên dưới.
- **Progress Card**: Hiển thị % hoàn thành **công việc (TaskProvider) + sự kiện (EventProvider)** trong ngày được chọn, không phải tất cả.
- **Công việc ưu tiên**: Lọc từ **TaskProvider** (bảng `tasks`), quadrant 0 (Làm ngay) + 1 (Lên lịch), có `dueDate` trùng với ngày được chọn. Tap card → `/tasks`.
- **Đang diễn ra**: Sự kiện (EventProvider) có `startTime < now < endTime`, chưa hoàn thành. Tự động ẩn nếu rỗng. Tap card → `/calendar` với ngày đã chọn.
- **Sự kiện sắp tới**: Sự kiện (EventProvider) có `startTime > now`, chưa hoàn thành. Tap card → `/calendar` với ngày đã chọn.
- **Đã bỏ lỡ**: Sự kiện (EventProvider) có `endTime < now`, chưa hoàn thành. Style riêng (opacity 0.6, border đỏ, title gạch ngang). Tự động ẩn nếu rỗng. Tap card → `/calendar` với ngày đã chọn.
- **User greeting**: Dynamic từ AuthProvider.user.name

### 5. Calendar
- **Lưới tháng**: Hiển thị đầy đủ các ngày, chấm màu theo danh mục cho ngày có sự kiện
- **Chuyển tháng**: Nút prev/next, chọn ngày
- **Agenda**: Danh sách sự kiện của ngày được chọn
- **Xóa sự kiện**: Dialog xác nhận + xóa từ DB

### 6. Add Event
- **Title**: TextField lớn
- **Date/Time**: Tap card → mở **DatePicker**, chọn xong tự động mở **TimePicker** (gộp `_pickDateTime()`). Áp dụng cho cả Bắt đầu và Kết thúc.
- **All Day Toggle**: Switch
- **Category**: Chip chọn từ danh mục có sẵn trong DB
- **Reminder**: Chọn 5/15/30 phút
- **Sub Tasks**: Thêm/xóa/toggle subtask (checkbox)
- **Save**: Lưu vào DB, pop về màn hình trước

### 7. Tasks (Eisenhower Matrix)
- 4 Quadrants: Làm ngay, Lên lịch, Ủy thác, Loại bỏ
- **Tự động populate từ EventProvider** (không còn nhập tay):
  - **Làm ngay** (0): Event trong 24h tới, chưa hoàn thành
  - **Lên lịch** (1): Event trong 7 ngày (>24h), chưa hoàn thành
  - **Ủy thác** (2): Event sau 7 ngày, chưa hoàn thành
  - **Loại bỏ** (3): Event đã hoàn thành
- **Toggle complete**: Checkbox → `toggleEventComplete()`
- **Delete**: Nút X → `deleteEvent()`
- **Header "+"**: Điều hướng đến `/add_event` để tạo sự kiện mới
- Không còn dùng bảng `tasks` — toàn bộ dữ liệu lấy từ `events`

### 8. Analytics
- **Header**: Tiến độ + Điểm hiệu suất (tính từ TaskProvider)
- **Bar Chart**: 7 ngày gần nhất
- **Time Distribution**: Donut chart + Legend
- **Focus Stats**: Tổng sự kiện, đã hoàn thành, còn lại (từ EventProvider)
- **Heatmap**: Legend trực quan
- **Smart Suggestions**: Gợi ý dựa trên dữ liệu thực

### 9. Settings
- **Profile Card**: Hiển thị tên + email động từ AuthProvider
- **Account Info**: Thông tin cá nhân
- **Theme**: Áp dụng theme thực tế (Light/Dark/System + 6 màu chủ đạo)
- **Notifications**: Toggle settings
- **Logout**: Gọi `AuthProvider.logout()` + chuyển về Login

### 10. Theme (Dynamic)
- ThemeProvider quản lý ThemeMode + ColorSeed
- AppTheme.buildTheme() tạo theme động từ color seed
- Áp dụng ngay lập tức, lưu trong runtime

## Data Layer

### Firebase Firestore (thay thế SQLite)
- Sử dụng `cloud_firestore` — real-time database qua snapshot listeners
- Offline persistence enabled mặc định (Android/iOS)
- Cache-first read strategy: đọc từ cache local trước, fallback về server
- Dùng `uuid` package sinh document id (thay auto-increment)

### `lib/data/repositories/event_repository.dart`
- `watchAllEvents()` — snapshot stream, real-time sync
- `getAllEvents()` — cache-first → fallback server
- `getEventsForDate`, `getEventsForRange`
- `getUpcomingEvents`, `getEventById`
- `insertEvent` (kèm subtasks subcollection), `updateEvent`, `deleteEvent`
- `toggleEventComplete`
- `getCompletedCountForDate`, `getTotalCountForDate`
- `getCategoryDistribution`
- `getSubTasksForEvent`, `getSubtaskCountsForDate`

### `lib/data/repositories/category_repository.dart`
- `watchAllCategories()` — snapshot stream
- `getAllCategories()` — cache-first → fallback server
- `insertCategory`, `updateCategory`, `deleteCategory`

### `lib/data/repositories/task_repository.dart`
- `watchAllTasks()` — snapshot stream
- `getAllTasks()` — cache-first → fallback server
- CRUD + toggle + thống kê cho TaskItem
- `getCompletedTasksByDay` (cho analytics)

## State Management (Provider)

### `lib/shared/providers/`
- **auth_provider.dart**: FirebaseAuth — login, register, logout, checkLoginStatus, User entity
- **theme_provider.dart**: ThemeMode + ColorSeed
- **event_provider.dart**: Optimistic updates — mutations cập nhật local RAM ngay, Firestore ghi ngầm sau; snapshot stream đồng bộ real-time
- **category_provider.dart**: Load từ cache/server, stream subscription cho real-time
- **task_provider.dart**: Optimistic updates + snapshot stream

## Navigation
Bottom Navigation Bar với 5 tabs (pushReplacementNamed):
- Trang chủ (/dashboard)
- Lịch (/calendar)
- Công việc (/tasks)
- Thống kê (/analytics)
- Cài đặt (/settings)

## Kiểm tra
- `flutter analyze` - Passes with 0 errors, 0 warnings, 8 info-level suggestions

## Bug Fixes

### 1. LocaleDataException tại tab "Lịch" (Calendar) — 17/05/2026

**Vấn đề**: Khi chuyển đến tab Lịch (Calendar), ứng dụng crash với lỗi `LocaleDataException: Locale data has not been initialized, call initializeDateFormatting(<locale>).` do `DateFormat('EEEE, ngày d tháng M', 'vi_VN')` trong `lib/features/calendar/calendar_screen.dart:364` được gọi mà chưa khởi tạo locale tiếng Việt.

**Fix** (`lib/main.dart`):
- Thêm `import 'package:intl/date_symbol_data_local.dart';` (hàm `initializeDateFormatting` nằm trong file này, không phải `package:intl/intl.dart`)
- Gọi `await initializeDateFormatting('vi_VN');` trong hàm `main()` trước `runApp()` để nạp dữ liệu locale tiếng Việt cho package `intl`.

### 2. Text Overflow (tràn chữ ra ngoài màn hình) — 17/05/2026

**Vấn đề**: Toàn bộ `Text` widget trong ứng dụng không có `overflow: TextOverflow.ellipsis`, dẫn đến tràn chữ gây lỗi "Bottom overflow" hoặc chữ bị che khuất trên màn hình nhỏ, đặc biệt là với nội dung động (tên người dùng, tiêu đề sự kiện dài, email, v.v.)

**Fix**: Áp dụng đồng bộ trên 11 file, gồm 2 thay đổi chính:

1. **Thêm `overflow: TextOverflow.ellipsis`** vào tất cả `Text` widget có nội dung động hoặc dài để tự động xuống dòng + hiển thị dấu "..." khi tràn.

2. **Bọc `Text` trong `Expanded`/`Flexible`** khi nằm trong `Row` để tránh đẩy các widget khác ra ngoài màn hình.

**Các file đã sửa**:

| File | Chi tiết |
|------|----------|
| `lib/features/dashboard/dashboard_screen.dart` | Header user name (Expanded + overflow), month title, empty state, event title/subtitle |
| `lib/features/calendar/calendar_screen.dart` | Formatted date (Expanded + overflow), event count, event list items, dialog, empty state |
| `lib/features/calendar/add_event_screen.dart` | Date/time display, subtask items |
| `lib/features/tasks/tasks_screen.dart` | Quadrant header title (Expanded + overflow), task items |
| `lib/features/settings/settings_screen.dart` | User name/email (Expanded + overflow), description |
| `lib/features/settings/account_info_screen.dart` | Info field values, security button title/subtitle (Expanded + overflow) |
| `lib/features/settings/notification_settings_screen.dart` | Toggle items, quick setting cards |
| `lib/features/settings/app_theme_screen.dart` | Section titles, descriptions |
| `lib/features/auth/login_screen.dart` | Subtitle, error message, footer text |
| `lib/features/auth/register_screen.dart` | Subtitle, error message |
| `lib/features/analytics/analytics_screen.dart` | Heatmap description, suggestion cards |
| `lib/features/onboarding/onboarding_screen.dart` | Slide title, description |

**Tổng số**: ~40+ `Text` widgets được thêm overflow, 7+ `Expanded` wrapper được thêm.

### 3. Sự kiện mới lưu sai ngày — 17/05/2026

**Vấn đề**: Khi thêm sự kiện từ tab Lịch (Calendar), ngày đã chọn trên lưới lịch không được truyền sang màn hình Thêm Sự Kiện. Màn hình AddEvent luôn khởi tạo `_startDate = DateTime.now()` (hôm nay), buộc người dùng phải chọn lại ngày thủ công.

**Fix**:
- `lib/features/calendar/calendar_screen.dart`: Truyền `_selectedDate` làm route argument khi gọi `Navigator.of(context).pushNamed('/add_event', arguments: _selectedDate)`
- `lib/features/calendar/add_event_screen.dart`: Đọc route argument trong `initState` qua `ModalRoute.of(context)?.settings.arguments` và cập nhật `_startDate`, `_endDate` tương ứng.

### 4. Nút "Thêm việc" (subtask) không hoạt động — 17/05/2026

**Vấn đề**: Nút "Thêm việc" trong mục Công Việc Con tại màn hình Thêm Sự Kiện có `onPressed: () {}` (rỗng), không làm gì khi nhấn.

**Fix** (`lib/features/calendar/add_event_screen.dart`):
- Thêm `FocusNode` cho TextField nhập subtask
- Đổi `onPressed` của nút "Thêm việc" thành `_subtaskFocusNode.requestFocus()` để focus vào ô nhập liệu

### 5. Công việc con không hiển thị sau khi lưu — 17/05/2026

**Vấn đề**: Subtasks được lưu vào bảng `subtasks` trong database nhưng không được load cùng event, và không hiển thị trong Agenda của Calendar.

**Fix** (3 file):
- `lib/data/repositories/event_repository.dart`: Thêm method `getSubtaskCountsForDate(DateTime date)` dùng LEFT JOIN để đếm số subtask cho mỗi event trong ngày
- `lib/shared/providers/event_provider.dart`: Thêm `_currentDaySubtaskCounts` và load trong `loadEventsForDate()`
- `lib/features/calendar/calendar_screen.dart`: Sửa `_eventListItem` nhận tham số `subtaskCount`, hiển thị dòng "X công việc con" màu primary bên dưới thời gian

### 6. Calendar view toggle (Tháng/Tuần/Ngày) không đổi giao diện — 17/05/2026

**Vấn đề**: Segmented control có 3 nút Tháng/Tuần/Ngày ở màn hình Lịch, biến `_viewIndex` được cập nhật khi bấm nhưng **không được dùng** trong logic render — cả 3 chế độ đều hiển thị lưới tháng + agenda giống hệt nhau (`calendar_screen.dart`).

**Fix** (`lib/features/calendar/calendar_screen.dart`):
- Thêm method `_buildWeekView()`: Hiển thị 7 cột ngày trong tuần với dấu chấm sự kiện, tap để chọn ngày xem agenda
- Thêm method `_buildDayView()`: Hiển thị lưới tháng đầy đủ (chọn ngày) + `_buildDetailedAgendaSection()` hiển thị chi tiết từng event kèm danh sách subtask (tên, checkbox hoàn thành, badge % tiến độ)
- Header title + nút mũi tên prev/next thay đổi hành vi theo từng chế độ (tháng/tuần/ngày)
- Thêm `_getWeekStart()`, `_getWeekEnd()` helpers

### 7. Agenda không cập nhật sau khi thêm/xóa sự kiện — 17/05/2026

**Vấn đề**: `EventProvider.addEvent()` và `deleteEvent()` chỉ gọi `loadEvents()` (refresh `_events`) mà không refresh `_currentDayEvents`. Màn hình Lịch đọc `currentDayEvents` để render agenda nên dữ liệu cũ vẫn hiển thị. Phải chuyển tab rồi quay lại mới thấy thay đổi.

**Fix** (`lib/shared/providers/event_provider.dart`):
- Thêm field `_lastLoadedDate` lưu ngày đã load gần nhất
- Trong `loadEventsForDate()`: gán `_lastLoadedDate = date`
- Sau mỗi CRUD (`addEvent`, `updateEvent`, `deleteEvent`, `toggleEventComplete`): nếu `_lastLoadedDate != null`, tự động gọi `loadEventsForDate(_lastLoadedDate!)` để refresh agenda ngay lập tức

### 8. DateFormat pattern "ngày d tháng M" hiển thị sai — 17/05/2026

**Vấn đề**: `DateFormat('EEEE, ngày d tháng M', 'vi_VN')` thiếu nháy đơn escape quanh "ngày" và "tháng". Các ký tự `y`, `d`, `h`, `M` trong pattern bị thư viện `intl` hiểu là **pattern letters** (năm/ngày/giờ/tháng) thay vì literal text. Kết quả: "Thứ Bảy, ngày 17 tháng 5" → "Thứ Bảy, ngà2026 17 t12áng5".

**Fix** (`lib/features/calendar/calendar_screen.dart`):
- Đổi `DateFormat('EEEE, ngày d tháng M', 'vi_VN')` → `DateFormat("EEEE, 'ngày' d 'tháng' M", 'vi_VN')` (dùng nháy đơn bên trong pattern string để giữ literal)
- Bọc Text header trong `Expanded` để tránh overflow khi hiển thị tên thứ dài (vd "Thứ Bảy")

### 9. Sự kiện nhiều ngày không hiển thị đủ — 18/05/2026

**Vấn đề**: `getEventsForDate()` chỉ query `WHERE startTime >= ? AND startTime < ?`, nên sự kiện start=18/5, end=20/5 chỉ hiển thị ở ngày 18/5. Ngày 19/5 và 20/5 không thấy sự kiện.

**Fix** (3 file):
- `lib/data/repositories/event_repository.dart`: Đổi query thành `WHERE startTime < ? AND endTime >= ?` (start trước cuối ngày AND end sau đầu ngày)
- `lib/data/repositories/event_repository.dart`: Fix tương tự cho `getSubtaskCountsForDate()`
- `lib/shared/providers/event_provider.dart`: Fix `getEventsOnDate()` dùng `isBefore`/`isAfter` thay vì so sánh year/month/day

### 10. Không thể chỉnh giờ kết thúc khi thêm sự kiện — 18/05/2026

**Vấn đề**: Card "Kết thúc" chỉ mở DatePicker, không mở TimePicker. Icon mũi tên ở giữa 2 card mở TimePicker cho thời gian **bắt đầu** (gây nhầm lẫn). Không có cách nào để chỉnh giờ kết thúc.

**Fix** (`lib/features/calendar/add_event_screen.dart`):
- Tạo `_pickDateTime(isStart)` — gọi DatePicker trước, TimePicker sau (tuần tự, như Google Calendar)
- Cả 2 card "Bắt đầu" và "Kết thúc" đều dùng `_pickDateTime()`
- Icon mũi tên giữa đổi thành `const Icon` (decorative), xoá `GestureDetector`

### 11. Dashboard hiển thị sai nguồn dữ liệu — 18/05/2026

**Vấn đề**: Dashboard có nhiều sai lệch về data source:
- "Công việc ưu tiên" dùng `EventProvider` (sự kiện) thay vì `TaskProvider` (Eisenhower tasks)
- "Sự kiện sắp tới" lọc `startTime > now` cho tất cả events (không theo ngày đã chọn)
- "Tiến độ hôm nay" đếm tất cả tasks (không theo ngày)
- Task tạo từ Eisenhower không có `dueDate` → không xuất hiện ở đâu trên Dashboard

**Fix** (3 file):
- `lib/features/dashboard/dashboard_screen.dart`:
  - **Công việc ưu tiên**: Chuyển từ `Consumer<EventProvider>` sang `Consumer<TaskProvider>`, lọc quadrant 0+1 theo `_selectedDate`
  - **Sự kiện sắp tới**: Lọc `startTime.isAfter(now)` cho `_selectedDate`
  - **Đang diễn ra** (mới): Lọc `start < now < end` cho `_selectedDate`, tự động ẩn
  - **Đã bỏ lỡ** (mới): Lọc `endTime.isBefore(now)` cho `_selectedDate`, style riêng, tự động ẩn
  - **Tiến độ hôm nay**: `Consumer2<TaskProvider, EventProvider>`, gộp cả tasks + events trong ngày
  - **Tap card**: Event card → `/calendar` với ngày; Task card → `/tasks`
- `lib/features/tasks/tasks_screen.dart`:
  - Chuyển từ `TaskProvider` sang `EventProvider`, xoá nhập tay
  - Quadrant mapping: 24h→Làm ngay, 7 ngày→Lên lịch, >7 ngày→Ủy thác, completed→Loại bỏ
- `lib/features/calendar/calendar_screen.dart`: Nhận `DateTime` argument để focus đúng ngày khi điều hướng từ Dashboard

### 12. Overflow ô ngày tháng trong event card — 18/05/2026

**Vấn đề**: Ô chứa ngày tháng (48x48) bị bottom overflow do fontSize 20 của số ngày cộng với font metrics của Plus Jakarta Sans vượt quá 48px.

**Fix** (`lib/features/dashboard/dashboard_screen.dart`):
- Xoá `height: 48` cố định trên Container
- Thêm `mainAxisSize: MainAxisSize.min` trên Column
- Container tự điều chỉnh chiều cao theo nội dung

### 13. Thêm danh mục "Ủy thác" + Đồng bộ dữ liệu — 18/05/2026

**Thay đổi** (6 files):

1. **Thêm category "Ủy thác"** (`lib/data/database/app_database.dart`):
   - Thêm seed "Ủy thác" (màu `#2196F3`) cho cài đặt mới
   - Nâng DB version lên 2, thêm `onUpgrade` để chèn cho DB cũ
   - Thêm `getCategoryByName()` trong `CategoryProvider`

2. **Tasks Screen — Eisenhower cập nhật** (`lib/features/tasks/tasks_screen.dart`):
   - **Ủy thác**: lọc theo `categoryId == 'Ủy thác'` (thay vì >7 ngày)
   - **Loại bỏ**: hiện sự kiện quá giờ chưa hoàn thành trong hôm nay
   - Loại trừ sự kiện "Ủy thác" khỏi `doNow`/`schedule` để tránh trùng
   - Sự kiện quá giờ của "Ủy thác" chỉ xuống "Loại bỏ", không ở lại "Ủy thác"
   - Thêm dòng danh mục cho mỗi sự kiện trong "Loại bỏ"
   - Thêm `intl` import để định dạng ngày giờ

3. **Dashboard — Checkmark + hiển thị** (`lib/features/dashboard/dashboard_screen.dart`):
   - Thêm checkbox (tick) cho: Đang diễn ra, Sự kiện sắp tới, Đã bỏ lỡ, Công việc ưu tiên
   - Bỏ `!e.isCompleted` khỏi bộ lọc → sự kiện đã tick vẫn hiển thị với checkmark

4. **Calendar — Ẩn FAB ngày cũ** (`lib/features/calendar/calendar_screen.dart`):
   - Ẩn nút "+" trong agenda nếu ngày đã chọn < hôm nay
   - Chỉ cho phép xem, không cho thêm sự kiện ở ngày cũ

5. **Add Event — Chặn ngày quá khứ** (`lib/features/calendar/add_event_screen.dart`):
   - `firstDate: today` trong DatePicker
   - Validation trong `_saveEvent()` + SnackBar báo lỗi nếu ngày < hôm nay

6. **Hiển thị chi tiết + thời gian còn lại** (`lib/features/tasks/tasks_screen.dart`):
   - Mỗi event row hiển thị: checkbox + tiêu đề + danh mục (Loại bỏ) + ngày giờ + thời gian còn lại
   - `_formatRemainingTime()`: tính giờ đến `startTime` (chưa bắt đầu) hoặc `endTime` (đang diễn ra)
   - Threshold "Sắp sẽ bắt đầu" dựa vào `reminderMinutes` của event
   - Threshold "Sắp sẽ kết thúc" = 15 phút
   - Không hiển thị phút (chỉ giờ/ngày) — trừ threshold báo "Sắp"

### 14. Luồng xử lý "Loại bỏ" khi tick hoàn thành

**Cơ chế**:
- **Loại bỏ**: chỉ hiện sự kiện `!isCompleted && endTime < now && endTime > todayStart`
- **Tick → hoàn thành**: `isCompleted = true` → biến mất khỏi "Loại bỏ"
- **Nếu danh mục "Ủy thác"** → về mục **Ủy thác** (checkmark)
- **Nếu danh mục khác** → về mục **Làm ngay** (checkmark) — làm điểm tập kết
- **Bỏ tick ở Ủy thác** mà quá giờ → xuống **Loại bỏ**

### 15. Database Migration

**Version 1 → 2** (`lib/data/database/app_database.dart`):
- Thêm category "Ủy thác" (colorHex: 0xFF2196F3)
- Kiểm tra trùng trước khi insert

### 16. Migration SQLite → Firebase Firestore + Auth — 19/05/2026

**Chuyển đổi toàn bộ backend từ local database sang Firebase**:

1. **Thay đổi Entity** (4 files):
   - `Event`, `Category`, `SubTask`, `TaskItem`: `id` từ `int` → `String` (Firestore document ID)
   - `SubTask`: `eventId` từ `int` → `String`

2. **Xóa `app_database.dart`** — không còn SQLite, migration, seed local

3. **Repositories viết lại hoàn toàn** (3 files — Firestore thay SQL):
   - `category_repository.dart`: `watchAllCategories()` stream + cache-first `getAllCategories()`
   - `event_repository.dart`: `watchAllEvents()` stream, subcollection `events/{id}/subtasks`
   - `task_repository.dart`: `watchAllTasks()` stream

4. **AuthProvider viết lại** (`auth_provider.dart`):
   - Import `firebase_auth` với alias `as firebase_auth` (tránh xung đột `User` entity local)
   - Dùng `FirebaseAuth.instance` thay `AppDatabase`
   - Các method: `signInWithEmailAndPassword`, `createUserWithEmailAndPassword`, `signOut`

5. **main.dart**:
   - `Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)` thay `AppDatabase().database`

6. **Thêm package**: `firebase_core`, `firebase_auth`, `cloud_firestore`, `uuid`
   **Xóa package**: `sqflite`, `path`

7. **Category seed mở rộng**: 8 danh mục mặc định (Công việc, Học tập, Sức khỏe, Cá nhân, Gia đình, Giải trí, Thể thao, Ủy thác) với màu sắc riêng

### 17. Fix: add_event_screen id type mismatch — 19/05/2026

**Vấn đề**: `_selectedCategoryId = '1'` (String) không khớp với category ID là UUID (Firestore), category picker dùng `'${cat.id}'` thừa string interpolation.

**Fix** (`add_event_screen.dart`):
- Default `_selectedCategoryId = ''`
- initState: nếu không có args, gán `cats.first.id`
- `'${cat.id}'` → `cat.id` (2 chỗ)

### 18. Fix: xung đột tên `User` giữa firebase_auth và entity local — 19/05/2026

**Vấn đề**: Cả `firebase_auth` và `lib/domain/entities/user.dart` đều export class `User`, gây lỗi `ambiguous_import`.

**Fix** (`auth_provider.dart`):
- Import alias: `import 'package:firebase_auth/firebase_auth.dart' as firebase_auth`
- Dùng `firebase_auth.FirebaseAuth`, `firebase_auth.FirebaseAuthException`

### 19. Optimize: Firestore performance — snapshot stream + optimistic updates — 19/05/2026

**Vấn đề**: App lag do Firestore network calls đồng bộ, mutation phải chờ write + reload.

**Fix** (6 files):

1. **main.dart**: Xóa `FirebaseFirestore.instance.settings` (persistence mặc định đã bật)

2. **CategoryProvider** — snapshot stream subscription + timeout 10s

3. **EventProvider** — snapshot stream + optimistic updates:
   - `addEvent()`: thêm vào `_events` local ngay, `insertEvent` fire-and-forget
   - `updateEvent()`: update local RAM, `updateEvent` background
   - `deleteEvent()`: xóa local, `deleteEvent` background
   - `toggleEventComplete()`: toggle local + `setState`, Firestore sync background
   - `loadEventsForDate()`: lọc từ `_events` trong bộ nhớ (0 network call)

4. **TaskProvider** — snapshot stream + optimistic updates tương tự EventProvider

5. **Splash screen**: auth + categories load song song (`Future.wait`), timeout 10-15s cho Firestore calls

6. **Timeout handlers**: tất cả Firestore reads có `.timeout()` + `try/catch` → nếu lỗi, app vẫn vào được với dữ liệu rỗng

### 20. Account Info: dynamic data từ Firebase — 19/05/2026

**Vấn đề**: Màn hình Thông tin tài khoản dùng dữ liệu hardcode (tên, email, SĐT, địa chỉ, tiến độ 85%).

**Fix** (`account_info_screen.dart` + `auth_provider.dart`):
- Thêm `firebaseUser` getter vào AuthProvider (trả về `FirebaseAuth.currentUser`)
- Tên hiển thị từ `AuthProvider.user.name`
- Email từ `AuthProvider.user.email`
- Phone từ `firebaseUser.phoneNumber`
- Xoá địa chỉ giả (chưa có dữ liệu)
- **Tiến độ tuần này**: tính từ dữ liệu thực — `(completedEvents + completedTasks) / (totalEvents + totalTasks) * 100` — dùng `context.watch<EventProvider>()` + `context.watch<TaskProvider>()` để real-time
- **Nút Xem chi tiết**: chuyển đến `/analytics` thay vì `onPressed: () {}`

## Kế hoạch sắp tới (Phase 3 — Hoàn thiện Firebase)

### Cần cấu hình Firebase Console
- **Firestore Database**: Tạo database, chọn region, set rules:
  ```
  rules_version = '2';
  service cloud.firestore {
    match /databases/{database}/documents {
      match /{document=**} {
        allow read, write: if request.auth != null;
      }
    }
  }
  ```
- **Authentication**: Bật Email/Password sign-in method

### Các tính năng khác cần hoàn thiện
- Local notifications (flutter_local_notifications)
- Filter events/userId (hiện tại chưa phân tách dữ liệu theo user)
- Recurring events logic
- Nâng cấp biểu đồ Analytics với fl_chart
- Data export (.ics)
- Biometric lock
